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
    item = "Thing One"
    item_id = subject.add( item )
    deleted_item = subject.delete(item_id)
    deleted_item.should eq item
    subject.find(item_id).should eq(nil)
  end
  
  it "can select items by criteria" do
    item_id = subject.add([1,2,3])
    subject.add([1])
    subject.select({:count => 3, :class => Array}).values.should eq([subject.find(item_id)])
  end
  
  it "can give me all items if select has no criteria" do
    item1 = subject.add([1,2,3])
    item2= subject.add([1])
    subject.select(nil).values.should =~ [[1,2,3], [1]]
  end
  
  it "has a count" do
    item_id = subject.add( "Thing One" )
    subject.count.should == 1
  end
  
  it "can re-add an item on the list" do
    item_1 = "Thing One"
    item_2 = "Thing Two"
    item_id_1 = subject.add(item_1)
    item_id_2 = subject.add(item_2)
    new_item_id = subject.move_to_end(item_1)
    new_item_id.should > item_id_2
    subject.find(new_item_id).should eq item_1
  end
  
  it "can give me the last item in a set" do
    item_1 = "Thing One"
    item_2 = "Thing Two"
    item_id_1 = subject.add(item_1)
    item_id_2 = subject.add(item_2)
    subject.last.should eq "Thing Two"
  end
  
  it "can give me the highest index key" do
    item_1 = "Thing One"
    item_2 = "Thing Two"
    item_id_1 = subject.add(item_1)
    item_id_2 = subject.add(item_2)
    subject.max_key.should eq item_id_2
  end
end
