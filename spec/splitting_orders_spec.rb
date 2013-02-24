# Magex Copyright 2013 Elisabeth Hendrickson
# See LICENSE.txt for licensing information

require 'spec_helper'

describe MagexServer do
  let(:seller)  { MagexServer.register("seller") }
  let(:buyer) { MagexServer.register("buyer") }
  let(:sell_order_data) {{
    :username => seller.username,
    :commodity => "wish",
    :action => "sell",
    :price => 5
  }}
  let(:buy_order_data) {{
    :username => buyer.username,
    :commodity => "wish",
    :action => "buy",
    :price => 5
  }}  

  before(:each) do
    MagexServer.reset
    MagexServer.add_to_account(seller, "wish", 50)
  end

  describe "splits orders" do
    it "when the buy order wants more quantity than seller offered" do
      sell_order = Order.new(sell_order_data.merge({:quantity => 5}))
      MagexServer.post_order(sell_order)
      buy_order = Order.new(buy_order_data.merge({:quantity => 10}))
      MagexServer.submit_order(buy_order)
      sell_order.status.should eq "completed"
      buy_order.status.should eq "split"
    end
    
    it "when the sell order offers more quantity than buyer wants" do
      sell_order = Order.new(sell_order_data.merge({:quantity => 10}))
      MagexServer.post_order(sell_order)
      buy_order = Order.new(buy_order_data.merge({:quantity => 5}))
      MagexServer.submit_order(buy_order)
      sell_order.status.should eq "split"
      buy_order.status.should eq "completed"
    end
    
  
  end
end