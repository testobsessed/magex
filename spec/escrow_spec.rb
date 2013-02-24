# Magex Copyright 2013 Elisabeth Hendrickson
# See LICENSE.txt for licensing information

require 'spec_helper'

describe EscrowAccount do

  before(:each) do
    MagexServer.reset
    @seller = MagexServer.register("seller")
    @buyer = MagexServer.register("buyer")
    @seller.add_to_balance(:wish, 10)
    @buy_order = Order.new({
      :action => "buy", 
      :price => 5,
      :commodity => "wish",
      :quantity => 10,
      :username => @buyer.username
    })
    MagexServer.post_order(@buy_order)
    @sell_order = Order.new({
      :action => "sell", 
      :price => 5,
      :commodity => "wish",
      :quantity => 10,
      :username => @seller.username
    })
    MagexServer.post_order(@sell_order)
    @escrow = EscrowAccount.new(@buy_order, @sell_order)
  end
  
  it "places orders into escrow state" do
    @buy_order.status.should eq "escrow"
    @sell_order.status.should eq "escrow"
  end
  
  it "can collect money from the buyer" do
    @buyer.balances[:gold].should eq 1000
    @escrow.collect_buyer_funds
    @buyer.balances[:gold].should eq 950
    @escrow.buyer_funded?.should eq true
  end
  
  it "can collect goods from the seller" do
    @seller.balances[:wish].should eq 10
    @escrow.collect_seller_goods
    @seller.balances[:wish].should eq 0
    @escrow.seller_funded?.should eq true
  end
  
  it "can complete the transaction" do
    @escrow.collect_buyer_funds
    @escrow.collect_seller_goods
    @escrow.complete_transaction
    @buyer.balances[:wish].should eq 10
    @buyer.balances[:gold].should eq 950
    @seller.balances[:wish].should eq 0
    @seller.balances[:gold].should eq 1050
    @buy_order.status.should eq "completed"
    @sell_order.status.should eq "completed"
  end
  
  it "shows buyer not funded if collecting funds fails" do
    @buyer.remove_from_balance(:gold, 1000)
    @escrow.collect_buyer_funds
    @escrow.buyer_funded?.should eq false
  end
  
  it "shows seller not funded if collecting commodity fails" do
    @seller.remove_from_balance(:wish, 10)
    @escrow.collect_seller_goods
    @escrow.buyer_funded?.should eq false
  end  
  
  it "can refund the buyer" do
    @escrow.collect_buyer_funds
    @escrow.refund
    @buyer.balances[:gold].should eq 1000
    @buy_order.status.should eq "open"
  end
  
  it "can refund the seller" do
    @escrow.collect_seller_goods
    @escrow.refund
    @seller.balances[:wish].should eq 10
    @sell_order.status.should eq "open"
  end
  
  it "moves an unfunded order to the end of the queue on refund" do
    @escrow.buyer_funded?.should eq false
    highest_buy_order_index = MagexServer.buy_orders.max_key
    @escrow.refund
    new_high_index = MagexServer.buy_orders.max_key 
    new_high_index.should > highest_buy_order_index
    MagexServer.buy_orders.get_index_for(@buy_order).should eq new_high_index
  end

  it "does not move a funded order to the end of the queue" do
    @escrow.seller_funded?.should eq false
    highest_sell_order_index = MagexServer.sell_orders.max_key
    @escrow.refund
    new_high_index = MagexServer.sell_orders.max_key 
    new_high_index.should > highest_sell_order_index
    MagexServer.sell_orders.get_index_for(@sell_order).should eq new_high_index
  end
end
