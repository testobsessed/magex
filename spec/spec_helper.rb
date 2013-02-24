# Magex Copyright 2013 Elisabeth Hendrickson
# See LICENSE.txt for licensing information

require 'rubygems'
require 'rspec'
require 'rack/test'

$LOAD_PATH << "./app"
require 'app'

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
  response = safe_parse(last_response.body)
  response[key]
end

def response_should_have_keys(key_array)
  response = safe_parse(last_response.body)
  response.keys.should =~ key_array
end

def response_should_be_success_with_keys(key_array)
  last_response.status.should eq(200)
  response_should_have_keys(key_array)
end

def response_should_be_error(code)
  last_response.status.should eq(code)
  response_should_have_keys(["code", "message"])
end

def safe_parse(text)
  begin
    response = JSON.parse(last_response.body)
  rescue Exception => e
    puts "ERROR while parsing response. Something went dreadfully wrong with the last response."
    response = {}
  end
  response
end

def test_transaction(commodity, quantity, price)
  seller = MagexServer.register(get_random_username)
  buyer = MagexServer.register(get_random_username)
  order_data = {
    :commodity => commodity,
    :price => price,
    :quantity => quantity
  }
  sell_order = Order.new(order_data.merge({:username => seller.username, :action => "sell"}))
  buy_order = Order.new(order_data.merge({:username => buyer.username, :action => "buy"}))
  MagexServer.post_order(sell_order)
  MagexServer.submit_order(buy_order)
end

def get_random_username
  timestamp = Time.now.to_i
  valid_characters = [('a'..'z')].map{|i| i.to_a}.flatten
  basename = (0...6).map{ valid_characters[rand(valid_characters.length)] }.join
  "#{basename}#{timestamp}"
end



