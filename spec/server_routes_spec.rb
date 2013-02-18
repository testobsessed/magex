require 'spec_helper'

describe "MagexServer Routes" do
  it "serves a home page" do
    get "/"
    last_response.ok?.should eq(true)
  end
  
  it "accepts registrations" do
    post "/account/register", { :username => "yakster" }.to_json
    response_should_have_keys ["username", "secret", "balances"]
  end
  
  it "returns a 400 if it cannot create an account" do 
    post "/account/register", "baddatahere"
    last_response.status.should eq(400)
  end
  
  it "gets account data from secret" do
    post "/account/register", { :username => "unicorn" }.to_json
    secret = get_from_response("secret")
    get "/account/status/#{secret}"
    response_should_have_keys ["username", "secret", "balances"]
  end
  
  it "returns a 404 if it cannot find an account from secret" do
    get "/account/status/foobar"
    last_response.status.should eq(404)
  end
  
end

def get_from_response(key)
  response = JSON.parse(last_response.body)
  response[key]
end

def response_should_have_keys(key_array)
  last_response.status.should eq(200)
  response = JSON.parse(last_response.body)
  response.keys.should =~ key_array
end