require 'spec_helper'

describe MagexServer do
  it "has accounts" do
    MagexServer.accounts.class.should eq(AccountCollection)
  end
end

