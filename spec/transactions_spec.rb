# Magex Copyright 2013 Elisabeth Hendrickson
# See LICENSE.txt for licensing information

require 'spec_helper'

describe MagexServer do
  let(:seller)  { MagexServer.register("yakster") }
  let(:buyer) { MagexServer.register("hamster") }
  let(:sell_order_data) {{
    "username" => seller.username,
    "commodity" => "wish",
    "quantity" => 50,
    "action" => "sell"
  }}
  let(:buy_order_data) {{
    "username" => buyer.username,
    "commodity" => "wish",
    "quantity" => 50,
    "action" => "buy"
  }}
  let(:sell_order_5g) { Order.new(sell_order_data.merge({"price" => 5})) }
  let(:buy_order_5g) { Order.new(buy_order_data.merge({"price" => 5})) }
  let(:sell_order_5gx) { Order.new(sell_order_data.merge({"price" => 5})) }
  let(:buy_order_5gx) { Order.new(buy_order_data.merge({"price" => 5})) }
  let(:sell_order_10g) { Order.new(sell_order_data.merge({"price" => 10})) }
  let(:buy_order_10g) { Order.new(buy_order_data.merge({"price" => 10})) }
  let(:sell_order_15g) { Order.new(sell_order_data.merge({"price" => 15})) }
  let(:buy_order_15g) { Order.new(buy_order_data.merge({"price" => 15})) }
  

  before(:each) do
    MagexServer.reset
  end

  it "matches new buy orders with existing sell orders" do
    MagexServer.post_order(sell_order_5g)
    MagexServer.match_available?(buy_order_5g).should eq true
  end
  
  it "matches new sell orders with existing buy orders" do
    MagexServer.post_order(buy_order_5g)
    MagexServer.match_available?(sell_order_5g).should eq true
  end
  
  it "returns matching buy orders sorted highest price to lowest earliest first" do
    MagexServer.post_order(buy_order_5g)
    MagexServer.post_order(buy_order_5gx)
    MagexServer.post_order(buy_order_15g)
    MagexServer.post_order(buy_order_10g)
    MagexServer.buyers(sell_order_5g).should eq [buy_order_15g, buy_order_10g, buy_order_5g, buy_order_5gx]
  end
  
  it "returns matching sell orders sorted lowest price to highest earliest first" do
    MagexServer.post_order(sell_order_15g)
    MagexServer.post_order(sell_order_5g)
    MagexServer.post_order(sell_order_5gx)
    MagexServer.post_order(sell_order_10g)
    MagexServer.sellers(buy_order_15g).should eq [sell_order_5g, sell_order_5gx, sell_order_10g, sell_order_15g]
  end
  
  it "does not offer up escrow orders in buyers" do
    MagexServer.post_order(buy_order_15g)
    MagexServer.post_order(buy_order_5g)
    buy_order_15g.in_escrow
    MagexServer.buyers(sell_order_5g).should eq [buy_order_5g]
  end

  it "does not offer up escrow orders in sellers" do
    MagexServer.post_order(sell_order_15g)
    MagexServer.post_order(sell_order_5g)
    sell_order_5g.in_escrow
    MagexServer.sellers(buy_order_15g).should eq [sell_order_15g]
  end

  it "does not offer up closed orders in buyers" do
    MagexServer.post_order(buy_order_15g)
    MagexServer.post_order(buy_order_5g)
    buy_order_15g.completed
    MagexServer.buyers(sell_order_5g).should eq [buy_order_5g]
  end

  it "does not offer up closed orders in sellers" do
    MagexServer.post_order(sell_order_15g)
    MagexServer.post_order(sell_order_5g)
    sell_order_5g.completed
    MagexServer.sellers(buy_order_15g).should eq [sell_order_15g]
  end
  
  it "can transfer balances into a user account" do
    seller.balances[:wish].should eq 0
    result = MagexServer.add_to_account(seller, "wish", 50)
    seller.balances[:wish].should eq 50
    result.should eq true
  end
  
  it "can transfer balances out of a user account" do
    MagexServer.add_to_account(seller, "wish", 50)
    seller.balances[:wish].should eq 50
    result = MagexServer.remove_from_account(seller, "wish", 50)
    seller.balances[:wish].should eq 0
    result.should eq true
  end
  
  it "cannot remove more than the account has" do
    MagexServer.add_to_account(seller, "wish", 50)
    seller.balances[:wish].should eq 50
    result = MagexServer.remove_from_account(seller, "wish", 100)
    seller.balances[:wish].should eq 50
    result.should eq false
  end
  
  it "can match and complete a transaction" do
    MagexServer.post_order(sell_order_5g)
    sell_order_5g.status.should eq "open"
    MagexServer.submit_order(buy_order_5g)
    buy_order_5g.status.should eq "completed"
    sell_order_5g.status.should eq "completed"
    MagexServer.transactions.count.should eq 1
  end
  
  it "splits an order if it can be partially completed" do
    pending "TBD"
  end
  
  it "completes the transaction with the best offer available if there are multiple" do
    MagexServer.post_order(sell_order_5g)
    MagexServer.post_order(sell_order_10g)
    MagexServer.post_order(sell_order_15g)
    MagexServer.submit_order(buy_order_15g)
    MagexServer.transactions.count.should eq 1
    MagexServer.transactions.values.first[:price].should eq 5
  end
  
  it "completes the transaction with the earliest available if the offers are all the same" do
    MagexServer.register("early")
    early_order = Order.new({
      "username" => "early",
      "commodity" => "wish",
      "quantity" => 50,
      "action" => "sell",
      "price" => 5
    })
    MagexServer.post_order(early_order)
    MagexServer.post_order(sell_order_5g)
    MagexServer.submit_order(buy_order_5g)
    MagexServer.transactions.values.first[:seller].should eq "early"
  end
end