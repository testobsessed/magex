# Magex Copyright 2013 Elisabeth Hendrickson
# See LICENSE.txt for licensing information

require 'spec_helper'

describe MagexServer do
  let(:order_data) {{
    "username" => "irrelevant",
    "commodity" => "wish",
    "quantity" => 50
  }}
  let(:sell_order_5g) { Order.new(order_data.merge({"action" => "sell", "price" => 5})) }
  let(:buy_order_5g) { Order.new(order_data.merge({"action" => "buy", "price" => 5})) }
  let(:sell_order_5gx) { Order.new(order_data.merge({"action" => "sell", "price" => 5})) }
  let(:buy_order_5gx) { Order.new(order_data.merge({"action" => "buy", "price" => 5})) }
  let(:sell_order_10g) { Order.new(order_data.merge({"action" => "sell", "price" => 10})) }
  let(:buy_order_10g) { Order.new(order_data.merge({"action" => "buy", "price" => 10})) }
  let(:sell_order_15g) { Order.new(order_data.merge({"action" => "sell", "price" => 15})) }
  let(:buy_order_15g) { Order.new(order_data.merge({"action" => "buy", "price" => 15})) }
  
  before(:each) do
    MagexServer.reset
  end
  # When a user places a buy order, it is automatically matched to a matching sell order
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
  
  it "can complete a transaction" do
    pending "Finish the bits"
    MagexServer.post_order(sell_order)
    sell_order.status.should eq "open"
    MagexServer.submit_order(buy_order)
    buy_order.status.should eq "completed"
    sell_order.status.should eq "completed"
    MagexServer.transactions.length.should eq 1
  end
  
  it "splits an order if it can be partially completed" do
    pending "TBD"
  end
  
  it "completes the transaction with the best offer available if there are multiple" do
    pending "TBD"
  end
  
  it "completes the transaction with the earliest available if the offers are all the same" do
    pending "TBD"
  end
end