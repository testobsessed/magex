# Magex Copyright 2013 Elisabeth Hendrickson
# See LICENSE.txt for licensing information

require 'spec_helper'

describe MagexCollection do
  subject { MagexCollection.new }
  
  it "can add an item to the collection" do
    item_id = subject.add( "Thing One" )
    subject.find(item_id).should eq("Thing One")
  end
    
  it "can remove an item from the collection" do
    item_id = subject.add( "Thing One" )
    subject.delete(item_id)
    subject.find(item_id).should eq(nil)
  end
  
  it "can select items by criteria" do
    item_id = subject.add([1,2,3])
    subject.add([1])
    subject.select({:count => 3, :class => Array}).should eq({ item_id => subject.find(item_id)})
  end
  
  it "has a count" do
    item_id = subject.add( "Thing One" )
    subject.count.should == 1
  end
end
