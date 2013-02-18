# Magex Copyright 2013 Elisabeth Hendrickson
# See LICENSE.txt for licensing information

require 'spec_helper'

describe MagexServer do
  it "has accounts" do
    MagexServer.accounts.class.should eq(AccountCollection)
  end
end

