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
      "action" => "sell", 
      "price" => 5,
      "commodity" => "wish",
      "quantity" => 10,
      "username" => @buyer.username
    })
    @sell_order = Order.new({
      "action" => "sell", 
      "price" => 5,
      "commodity" => "wish",
      "quantity" => 10,
      "username" => @seller.username
    })
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
  
end
