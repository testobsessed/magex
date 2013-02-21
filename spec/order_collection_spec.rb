# Magex Copyright 2013 Elisabeth Hendrickson
# See LICENSE.txt for licensing information

require 'spec_helper'

describe OrderCollection do
  let(:order_data) {{
    "username" => "irrelevant",
    "commodity" => "wish",
    "quantity" => 50,
    "action" => "buy"
  }}
  let(:buy_order_cheap) { Order.new(order_data.merge("price" => 5)) }
  let(:buy_order_expensive) { Order.new(order_data.merge("price" => 50)) }
  
  subject { OrderCollection.new }
  
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
    subject.price_at_least(5).should eq [buy_order_cheap, buy_order_expensive]
  end
  
  it "can find orders priced at most" do
    subject.add(buy_order_cheap)
    subject.add(buy_order_expensive)
    subject.price_at_most(5).should eq [buy_order_cheap]
  end
  
end