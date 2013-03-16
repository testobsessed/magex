# Magex Copyright 2013 Elisabeth Hendrickson
# See LICENSE.txt for licensing information

require 'spec_helper'

describe MagexServer do
  
  before(:each) { MagexServer.reset }
  
  it "has accounts" do
    MagexServer.accounts.class.should eq(AccountCollection)
  end
  
  it "can tell an object what the next unique, sequential id should be" do
    MagexServer.next_id.should eq(1)
    50.times { MagexServer.next_id }
    MagexServer.next_id.should eq(52)
  end
  
  describe "report valuation of commodities" do
    it "returns -1 if the commodity has no transactions" do
      MagexServer.calculate_valuation(:sisw).should eq -1
    end
    
    it "returns the price of the last trade if there was just 1 transaction" do
      test_transaction(:flyc, 1, 50)
      MagexServer.calculate_valuation(:flyc).should eq 50
    end
    
    it "averages only the last 5 transactions" do
      # note that max quantity a new user can sell is 10
      # and max gold is 1000. So 10 * 100 is the max order
      test_transaction(:mbns, 10, 100) 
      5.times { test_transaction(:mbns, 1, 1) }
      MagexServer.calculate_valuation(:mbns).should eq 1
    end
    
    it "weights the average by quantity traded" do
      # 500 gold for 10 sisw
      test_transaction(:sisw, 10, 50)  
      # 4 gold for 4 sisw         
      4.times { test_transaction(:sisw, 1, 1) } 
      # 504 gold / 14 sisw = 36 gold / sisw
      MagexServer.calculate_valuation(:sisw).should eq 36
    end
    
    it "can report all valuations" do
      starting_valuations = {
        :wish => -1,
        :flyc => -1,
        :sisw => -1,
        :mbns => -1,
        :pixd => -1
      }
      MagexServer.market_valuations.should eq starting_valuations
    end
    
  end
end