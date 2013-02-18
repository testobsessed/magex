require 'spec_helper'

describe AccountCollection do
  subject { AccountCollection.new }
  let(:account)  { Account.new({ "username" => "unicorn" }) }
  let(:secret) { account.secret }
  it "can add an account" do
    subject.add(account)
    subject.count.should eq(1)
  end
end
