# Magex Copyright 2013 Elisabeth Hendrickson
# See LICENSE.txt for licensing information

require 'spec_helper'

describe "MagexServer Routes" do
  it "serves a home page" do
    get "/"
    last_response.ok?.should eq(true)
  end
  
end