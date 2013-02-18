# Magex Copyright 2013 Elisabeth Hendrickson
# See LICENSE.txt for licensing information

require 'spec_helper'

describe AccountCollection do
  subject { AccountCollection.new }
  let(:account)  { Account.new({ "username" => "unicorn" }) }
  let(:secret) { account.secret }
  
  it "can add an account" do
    subject.add(account)
    subject.count.should eq(1)
  end
  
  it "can determine if a username is already taken" do
    subject.has_user("unicorn").should == false
    subject.add(account)
    subject.has_user("unicorn").should == true 
  end
end
