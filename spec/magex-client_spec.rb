# Magex Copyright 2013 Elisabeth Hendrickson
# See LICENSE.txt for licensing information

require 'magex-server-runner'

describe MagexClient do
  let(:magex_url) { "http://localhost:4567" }
  let(:starting_balances) {{
    :gold => 1000,
    :wish => 10,
    :flyc => 10,
    :sisw => 10,
    :mbns => 10,
    :pixd => 10    
  }}
  
  before(:all) do
    @gekko = MagexClient.new("gekko", magex_url)
    @mortimer = MagexClient.new("mortimer", magex_url)
  end
  
  it "Can check balances" do
    @gekko.balances.should eq starting_balances
    @mortimer.balances.should eq starting_balances
  end
  
  it "Can create a buy order" do
    @gekko.buy(:wish, 5, 10)
    @gekko.open_buy_orders.should eq [
      {
        :commodity => :wish,
        :quantity => 5,
        :price => 10,
      }
    ]
  end
  
  it "Can create a sell order" do
    @gekko.sell(:pixd, 5, 10)
    @gekko.open_sell_orders.should eq [
      {
        :commodity => :pixd,
        :quantity => 5,
        :price => 10,
      }
    ]
  end
  
  describe "Can complete a split transaction" do
    before(:all) do
      @gekko.sell(:mbns, 1, 5)
      @mortimer.buy(:mbns, 2, 10)
    end
    
    it "and transfer balances" do
      @gekko.balances[:gold].should eq 1005
      @gekko.balances[:mbns].should eq 9
      @mortimer.balances[:gold].should eq 995
      @mortimer.balances[:mbns].should eq 11
    end
    
    it "and leave the unfulfilled part of the order open" do
      @gekko.open_sell_orders(:mbns).should eq []
      @mortimer.open_buy_orders(:mbns).should eq [
        :commodity => :mbns,
        :quantity => 1,
        :price => 10,
      ]
    end
  end
  
    
end

