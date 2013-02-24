# Magex Copyright 2013 Elisabeth Hendrickson
# See LICENSE.txt for licensing information

require 'spec_helper'

describe Order do
  let(:order_data) {{
    :username => "cinderella",
    :commodity => "wish",
    :quantity => 50,
    :price => 5,
    :action => "sell"
  }}
  let(:order) { Order.new(order_data) }
  
  subject { order.data }
  describe "data has a JSON shape" do
    it { should include(:username) }
    it { should include(:status) }
    it { should include(:commodity) }
    it { should include(:quantity) }
    it { should include(:price) }
    it { should include(:action) }
    it { should include(:order_id) }
  end
  
  describe "has the right values" do
    it "is attributed to a username" do
      subject[:username].should eq("cinderella")
    end
    
    it "reflects the requested commodity" do
      subject[:commodity].should eq("wish")
    end
    
    it "reflects the requested quantity" do
      subject[:quantity].should eq(50)
    end
    
    it "reflects the requested price" do
      subject[:price].should eq(5)
    end
    
    it "reflects the action (buy or sell)" do
      subject[:action].should eq("sell")
    end
    
    it "is open" do
      subject[:status].should eq("open")
    end
    
  end

  it "has a unique ID" do
    orders = Array.new
    expected_ids = Array.new(10)
    # to avoid over-constraining this test and making it brittle,
    # it gets the next_id from the server and uses that to determine
    # the expectation.
    start = MagexServer.next_id
    expected_ids.map!{ start += 1 }
    10.times { orders.push(Order.new(order_data)) }
    orders.map {|o| o.order_id }.should =~ expected_ids
  end
end
