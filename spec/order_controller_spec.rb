# Magex Copyright 2013 Elisabeth Hendrickson
# See LICENSE.txt for licensing information

require 'spec_helper'

describe "Buy order routes" do
  before(:all) do
    MagexServer.reset
    @secret = create_account_named("hamster")    
    @order_data = { 
        :secret => @secret, 
        :commodity => "wish", 
        :quantity => "50",
        :price => "10"
    }
    post "/orders/buy", @order_data.to_json
  end
  
  it "give a successful response with all the right keys" do
    response_should_be_success_with_keys(
      ["code", 
       "order_id", 
       "action", 
       "status", 
       "username", 
       "commodity", 
       "quantity", 
       "price"])
   end
  
   it "make the status open if no matching sell order is available" do
     get_from_response("status").should eq("open")
   end
  
   it "look up the username from the secret" do
     get_from_response("username").should eq("hamster")
   end
  
   it "confirm that it was a buy order" do
     get_from_response("action").should eq("buy")
   end
end

describe "Sell order routes" do
  before(:all) do
    MagexServer.reset
    @secret = create_account_named("hamster")
    @order_data = { 
        :secret => @secret, 
        :commodity => "wish", 
        :quantity => "50",
        :price => "10"
    }
    post "/orders/sell", @order_data.to_json
  end
  
  it "give a successful response with all the right keys" do
    response_should_be_success_with_keys(
      ["code", 
       "order_id", 
       "action", 
       "status", 
       "username", 
       "commodity", 
       "quantity", 
       "price"])
  end
  
  it "make the status open if no matching sell order is available" do
    get_from_response("status").should eq("open")
  end
  
  it "look up the username from the secret" do
    get_from_response("username").should eq("hamster")
  end
  
  it "confirm that it was a sell order" do
    get_from_response("action").should eq("sell")
  end
end
  
describe "for invalid orders" do
  it "rejects invalid buy orders with an error" do
    post "/orders/buy", "completegarbage"
    response_should_be_error 400
  end
  
  it "rejects invalid sell orders with an error" do
    post "/orders/sell", "completegarbage"
    response_should_be_error 400
  end
end

describe "for queries" do
  before(:all) do
    MagexServer.reset
    @user1 = create_account_named("hamster")
    @user2 = create_account_named("hipster")
    @buy_order_data = { 
        :quantity => "50",
        :price => "10"
    }
    @sell_order_data = { 
        :quantity => "50",
        :price => "50"
    }
    post "/orders/sell", @sell_order_data.merge({:commodity => "wish", :secret => @user1 }).to_json
    post "/orders/sell", @sell_order_data.merge({:commodity => "wish", :secret => @user2 }).to_json
    post "/orders/sell", @sell_order_data.merge({:commodity => "flyc", :secret => @user2 }).to_json
    post "/orders/buy", @buy_order_data.merge({:commodity => "pixd", :secret => @user1 }).to_json
    post "/orders/buy", @buy_order_data.merge({:commodity => "pixd", :secret => @user2 }).to_json
    post "/orders/buy", @buy_order_data.merge({:commodity => "mbns", :secret => @user2 }).to_json
  end
  
  it "can find all open sell orders" do
    get "/orders/sell?status=open"
    response_should_be_success_with_keys ["code", "orders"]
    response_json = JSON.parse(last_response.body)
    response_json["orders"].length.should eq(3)
    response_json["orders"].values.map {|order| order["action"]}.uniq.should eq(["sell"])
    response_json["orders"].values.map {|order| order["commodity"]}.uniq.should =~ ["flyc", "wish"]
  end

  it "can find all open sell orders for a given commodity" do
    get "/orders/sell?status=open&commodity=wish"
    response_should_be_success_with_keys ["code", "orders"]
    response_json = JSON.parse(last_response.body)
    response_json["orders"].length.should eq(2)
    response_json["orders"].values.map {|order| order["action"]}.uniq.should eq(["sell"])
    response_json["orders"].values.map {|order| order["commodity"]}.uniq.should eq(["wish"])
  end

  it "can find all open sell orders for a given user" do
    get "/orders/sell?status=open&commodity=flyc&username=hipster"
    response_should_be_success_with_keys ["code", "orders"]
    response_json = JSON.parse(last_response.body)
    response_json["orders"].length.should eq(1)
    response_json["orders"].values.map {|order| order["action"]}.should eq(["sell"])
    response_json["orders"].values.map {|order| order["commodity"]}.should eq(["flyc"])
  end
  it "can find all open buy orders" do
    get "/orders/buy?status=open"
    response_should_be_success_with_keys ["code", "orders"]
    response_json = JSON.parse(last_response.body)
    response_json["orders"].length.should eq(3)
    response_json["orders"].values.map {|order| order["action"]}.uniq.should eq(["buy"])
    response_json["orders"].values.map {|order| order["commodity"]}.uniq.should =~ ["pixd", "mbns"]
  end

  it "can find all open buy orders for a given commodity" do
    get "/orders/buy?status=open&commodity=pixd"
    response_should_be_success_with_keys ["code", "orders"]
    response_json = JSON.parse(last_response.body)
    response_json["orders"].length.should eq(2)
    response_json["orders"].values.map {|order| order["action"]}.uniq.should eq(["buy"])
    response_json["orders"].values.map {|order| order["commodity"]}.uniq.should eq(["pixd"])
  end

  it "can find all open sell orders for a given user" do
    get "/orders/buy?status=open&commodity=pixd&username=hipster"
    response_should_be_success_with_keys ["code", "orders"]
    response_json = JSON.parse(last_response.body)
    response_json["orders"].length.should eq(1)
    response_json["orders"].values.map {|order| order["action"]}.should eq(["buy"])
    response_json["orders"].values.map {|order| order["commodity"]}.should eq(["pixd"])
  end  
end

