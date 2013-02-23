# Magex Copyright 2013 Elisabeth Hendrickson
# See LICENSE.txt for licensing information

require 'spec_helper'

describe EscrowAccount do
  let(:seller) { Account.new("seller") }
  let(:buyer) { Account.new("buyer") }  
  before(:each) { seller.add_to_balance(:wish, 10) }
  
  let(:sell_order) do
    Order.new({
      "action" => "sell", 
      "price" => 5,
      "commodity" => "wish",
      "quantity" => 10,
      "username" => "seller"
    }) 
  end
  
  let(:buy_order) do
    Order.new({
      "action" => "sell", 
      "price" => 5,
      "commodity" => "wish",
      "quantity" => 10,
      "username" => "buyer"
    }) 
  end
  
  subject { EscrowAccount.new(buy_order, sell_order) }
  
  it "places orders into escrow state" do
    pending
    buy_order.status.should eq "escrow"
    sell_order.status.should eq "escrow"
  end
  
  it "can collect money from the buyer" do
    pending
    buyer.balances[:gold].should eq 1000
    subject.collect_buyer_funds
    buyer.balances[:gold].should eq 950
    subject.buyer_funded?.should eq true
  end
  
  it "can collect goods from the seller" do
    pending
    subject.collect_seller_goods
    buyer.balances[:wish].should eq 0
    subject.seller_funded?.should eq true
  end
  
  it "can complete the transaction" do
    pending
    subject.collect_buyer_funds
    subject.collect_seller_goods
    subject.complete_transaction
    seller.balances[:wish].should eq 10
    buyer.balances[:gold].should eq 1050
    buy_order.status.should eq "completed"
    sell_order.status.should eq "completed"
    MagexServer.transactions.add ( Transaction.new (buy_order, sell_order) )    
  end
  
end
