# Magex Copyright 2013 Elisabeth Hendrickson
# See LICENSE.txt for licensing information

require 'spec_helper'

describe OrderCollection do
  let(:order_data) {{
    :username => "irrelevant",
    :commodity => "wish",
    :quantity => 50,
    :action => "buy"
  }}
  let(:buy_order_cheap) { Order.new(order_data.merge(:price => 5)) }
  let(:buy_order_expensive) { Order.new(order_data.merge(:price => 50)) }
  
  subject { OrderCollection.new }
  
  before(:each) do
    MagexServer.reset
  end
  
  it "can find no matches if there are no orders" do
    subject.price_at_least(5).should eq []
  end
  
  it "can find no suitable matches" do
    subject.add(buy_order_cheap)
    subject.add(buy_order_expensive)
    subject.price_at_most(1).should eq []
  end
  
  it "can find orders priced at least" do
    subject.add(buy_order_cheap)
    subject.add(buy_order_expensive)
    subject.price_at_least(5).should =~ [buy_order_cheap, buy_order_expensive]
  end
  
  it "can find orders priced at most" do
    subject.add(buy_order_cheap)
    subject.add(buy_order_expensive)
    subject.price_at_most(5).should eq [buy_order_cheap]
  end
  
  it "finds orders by order_id not collection id" do
    order_id = buy_order_cheap.order_id
    index_in_collection = subject.add(buy_order_cheap)
    order_id.should_not eq index_in_collection # otherwise this test is meaningless
    subject.find(order_id).should eq buy_order_cheap
  end
    
  it "can move an order to the end" do
    subject.add(buy_order_cheap)
    subject.add(buy_order_expensive)
    subject.move_to_end(buy_order_cheap)
    subject.last.should eq buy_order_cheap
  end
  
  it "can split an order into two" do
    subject.add(buy_order_cheap)
    split_order = subject.split_order(buy_order_cheap, 10)
    split_order.parent_id.should eq buy_order_cheap.order_id
    buy_order_cheap.status.should eq "split"
    buy_order_cheap.children.length.should eq 2
    buy_order_cheap.children.first.should eq split_order.order_id
    other_order = subject.find(buy_order_cheap.children.last)
    split_order.status.should eq "open"
    other_order.status.should eq "open"
    split_order.quantity.should eq 10
    other_order.quantity.should eq 40
    subject.get_index_for(buy_order_cheap).should > 0
  end
  
end