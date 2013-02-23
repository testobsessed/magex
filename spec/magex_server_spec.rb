# Magex Copyright 2013 Elisabeth Hendrickson
# See LICENSE.txt for licensing information

require 'spec_helper'

describe MagexServer do
  
  before(:each) { MagexServer.reset }
  
  it "has accounts" do
    MagexServer.accounts.class.should eq(AccountCollection)
  end
  
  it "can tell an object what the next unique, sequential id should be" do
    MagexServer.next_id.should eq(1)
    50.times { MagexServer.next_id }
    MagexServer.next_id.should eq(52)
  end
end

