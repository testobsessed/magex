# Magex Copyright 2013 Elisabeth Hendrickson
# See LICENSE.txt for licensing information

require 'spec_helper'

describe MagexServer do
  # When a user places a buy order, it is automatically matched to a matching sell order
  it "matches new buy orders with existing sell orders" do
    
  end
  
  it "matches new sell orders with existing buy orders" do
    pending "TBD"
  end
  
  it "splits an order if it can be partially completed" do
    pending "TBD"
  end
  
  it "matches the best offer available if there are multiple" do
    pending "TBD"
  end
  
  it "matches the earliest available if the offers are all the same" do
    pending "TBD"
  end
end