# Magex Copyright 2013 Elisabeth Hendrickson
# See LICENSE.txt for licensing information

require 'spec_helper'

describe "Order routes" do
  it "can accept new buy orders" do
    secret = create_account_named("hamster")
    order_data = { 
      :secret => secret, 
      :commodity => "wish", 
      :quantity => 50,
      :max_price => 10
    }
    post "/orders/buy", order_data.to_json
    response_should_be_success_with_keys(
      ["code", 
       "order_id", 
       "type", 
       "status", 
       "username", 
       "commodity", 
       "quantity", 
       "price"])
    get_from_response("status").should eq("open")
  end
  
  it "can accept new sell orders" do
    pending ("to be implemented")
    secret = create_account_named("hamster")
    order_data = { 
      :secret => secret, 
      :commodity => "wish", 
      :quantity => 50,
      :min_price => 10
    }
    post "/orders/sell", order_data.to_json
    last_response.status.should eq(200)
    response_should_be_success_with_keys(["order_id", "type", "status", "secret", "commodity", "quantity", "min_price"])
    get_from_response("status").should eq("open")
  end
  
  it "can match a new sell with an existing buy order" do
    pending ("to be implemented")
    buyer = create_account_named("buyer")
    seller = create_account_named("seller")
    MagexServer.add_commodity_to_account(seller, "wish", 50)
    place_buy_order({
      :secret => buyer, 
      :commodity => "wish", 
      :quantity => 50, 
      :price => 10
    })
    place_sell_order({
      :secret => seller, 
      :commodity => "wish", 
      :quantity => 50, 
      :price => 10
    })
    last_response.status.should eq(200)
    get_from_response("status").should eq("completed")
  end
  
  it "can reject an order if the data is malformed" do
    pending ("to be implemented")
  end
  
  it "can find all open sell orders" do
    pending ("to be implemented")
  end
  
  it "can find all open sell orders for a given commodity" do
    pending ("to be implemented")
  end
  
  it "can find all open sell orders for a given user" do
    pending ("to be implemented")
  end
  
  it "can find all open buy orders" do
    pending ("to be implemented")
  end
  
  it "can find all open buy orders for a given commodity" do
    pending ("to be implemented")
  end
  
  it "can find all open buy orders for a given user" do
    pending ("to be implemented")
  end
  
  it "can find all completed orders" do
    pending ("to be implemented")
  end
  
  it "can find all completed orders for a given commodity" do
    pending ("to be implemented")
  end
  
end
