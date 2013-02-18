# Magex Copyright 2013 Elisabeth Hendrickson
# See LICENSE.txt for licensing information

require 'spec_helper'

describe Order do
  let(:order_data) {{
    "username" => "cinderella",
    "commodity" => "wish",
    "quantity" => 50,
    "price" => 5,
    "type" => "buy"
  }}
  let(:order) { Order.new(order_data) }
  
  subject { order.data }
  describe "data has a JSON shape" do
    it { should include(:username) }
    it { should include(:status) }
    it { should include(:commodity) }
    it { should include{:quantity} }
    it { should include{:price} }
    it { should include{:type} }
  end
  
  describe "has the right values" do
    it "is attributed to a username" do
      subject[:username].should eq("cinderella")
    end
    
    it "reflects the requested commodity type" do
      subject[:commodity].should eq("wish")
    end
    
    it "reflects the requested quantity" do
      subject[:quantity].should eq(50)
    end
    
    it "reflects the requested price" do
      subject[:price].should eq(5)
    end
    
    it "reflects the type of offer" do
      subject[:type].should eq("buy")
    end
    
    it "is open" do
      subject[:status].should eq("open")
    end
  end
end
