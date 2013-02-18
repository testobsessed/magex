# Magex Copyright 2013 Elisabeth Hendrickson
# See LICENSE.txt for licensing information

require 'spec_helper'

describe "Account routes" do
  it "accept registrations" do
    post "/account/register", { :username => "yakster" }.to_json
    response_should_be_success_with_keys ["code", "username", "secret", "balances"]
  end
  
  it "reject registration if username is already taken" do
    post "/account/register", { :username => "unicorn" }.to_json
    post "/account/register", { :username => "unicorn" }.to_json
    response_should_be_error 409
  end

  it "return a 400 if it cannot create an account" do 
    post "/account/register", "baddatahere"
    response_should_be_error 400
  end

  it "get account data from secret" do
    secret = create_account_named("pegasus")
    get "/account/status/#{secret}"
    response_should_be_success_with_keys ["code", "username", "secret", "balances"]
  end

  it "return a 404 if it cannot find an account from secret" do
    get "/account/status/foobar"
    response_should_be_error 404
  end
end