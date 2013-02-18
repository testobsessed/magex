require 'spec_helper'

describe "Order routes" do
  it "accept new buy orders" do
    pending ("to be implemented")
    secret = create_account_named("hamster")
    order_data = { 
      :secret => secret, 
      :commodity => "wish", 
      :quantity => 50,
      :max_price => 10
    }
    post "/orders/buy", order_data.to_json
    last_response.status.should eq(200)
    response_should_have_keys(["order_id", "type", "status", "secret", "commodity", "quantity", "max_price"])
    get_from_response("status").should eq("completed")
  end
  
  it "accept new sell orders" do
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
    response_should_have_keys(["order_id", "type", "status", "secret", "commodity", "quantity", "min_price"])
    get_from_response("status").should eq("open")
  end
  
  it "matches a new sell with an existing buy order" do
    pending ("to be implemented")
    buyer = create_account_named("buyer")
    seller = create_account_named("seller")
    MagexServer.add_commodity_to_account(seller, "wish", 50)
    place_buy_order({
      :secret => buyer, 
      :commodity => "wish", 
      :quantity => 50, 
      :max_price => 10
    })
    place_sell_order({
      :secret => seller, 
      :commodity => "wish", 
      :quantity => 50, 
      :min_price => 10
    })
    last_response.status.should eq(200)
    get_from_response("status").should eq("completed")
  end
end
