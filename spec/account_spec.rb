# Magex Copyright 2013 Elisabeth Hendrickson
# See LICENSE.txt for licensing information

require 'spec_helper'

describe Account do
  let(:username) { "yakster" }
  let(:request_data) { { "username" => username } }
  let(:account)  { Account.new(request_data) }
  describe "can retrieve a hash of account data" do
    subject { account.data }
    it { should have_exactly(3).items }
    it { should include(:username) }
    it { should include(:secret) }
    it { should include(:balances)}
  end
  
  it "has the specified username" do
    account.data[:username].should eq(username)
  end
  
  it "has a random string of 50 characters for the secret" do
    account.data[:secret].should =~ /^[a-zA-Z0-9]{50}$/
  end
  
  it "can tell you its secret (shhh)" do
    account.secret.should eq(account.data[:secret])
  end
  
  describe "balance manipulation" do
    
    it "can add to a balance" do
      result = account.add_to_balance(:wish, 50)
      account.data[:balances][:wish].should eq 50
      result.should eq true
    end
    
    it "can remove from a balance" do
      result = account.remove_from_balance(:gold, 1000)
      account.data[:balances][:gold].should eq 0
      result.should eq true
    end
    
    it "cannot remove more than an account has" do
      result = account.remove_from_balance(:gold, 1001)
      account.data[:balances][:gold].should eq 1000
      result.should eq false
    end
    
    it "cannot remove a negative quantity" do
      result = account.remove_from_balance(:gold, -5)
      account.data[:balances][:gold].should eq 1000
      result.should eq false
    end
    
    it "cannot add a negative quantity" do
      result = account.add_to_balance(:gold, -10)
      account.data[:balances][:gold].should eq 1000
      result.should eq false
    end

  end
  
  describe "balances" do
    subject { account.data[:balances] }
    it { should include(:gold) }
    it { should include(:wish) }
    it { should include(:flyc) }
    it { should include(:sisw) }
    it { should include(:mbns) }
    it { should include(:pixd) }
    
    it "has an initial balance of gold" do
      subject[:gold].should > 0
    end
    
    it "has an zero balance for all other commodities" do
      commodities = subject.keys - [:gold]
      balances = commodities.map {|key| subject[key] }
      balances.each { |val| val.should eq(0) }
    end
    
  end
  
  it "generates random secret keys" do
    test_length = 999
    secrets = Array.new(test_length)
    secrets.map! { Account.generate_secret }
    secrets.uniq.length.should eq(test_length)
  end
  
end
