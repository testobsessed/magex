require 'spec_helper'
describe MagexServer do
  it "serves a home page" do
    get "/"
    last_response.ok?.should eq(true)
  end
  
  it "accepts registrations" do
    post '/register', { :username => "yakster" }.to_json
    response_should_have_keys ["username", "secret", "balances"]
  end
end

def response_should_have_keys(key_array)
  response = JSON.parse(last_response.body)
  response.keys.should =~ key_array
end