require 'rubygems'
require 'rspec'
require 'rack/test'
$LOAD_PATH << "."
$LOAD_PATH << "./app"

require 'app'
Dir["app/models/*.rb"].each {|file| require file }
Dir["app/controllers/*.rb"].each {|file| require file }
Dir["app/helpers/*.rb"].each {|file| require file }

set :environment, :test

def app
  MagexServer
end

RSpec.configure do |conf|
  conf.include Rack::Test::Methods
end

def create_account_named(username)
  post "/account/register", { :username => username }.to_json
  get_from_response("secret")
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
