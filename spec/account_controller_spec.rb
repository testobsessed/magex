require 'spec_helper'

describe "Account routes" do
  it "accept registrations" do
    post "/account/register", { :username => "yakster" }.to_json
    response_should_have_keys ["username", "secret", "balances"]
  end
  
  it "reject registration if username is already taken" do
    pending ("to be implemented")
  end

  it "return a 400 if it cannot create an account" do 
    post "/account/register", "baddatahere"
    last_response.status.should eq(400)
  end

  it "get account data from secret" do
    secret = create_account_named("pegasus")
    get "/account/status/#{secret}"
    response_should_have_keys ["username", "secret", "balances"]
  end

  it "return a 404 if it cannot find an account from secret" do
    get "/account/status/foobar"
    last_response.status.should eq(404)
  end
end