# Magex Copyright 2013 Elisabeth Hendrickson
# See LICENSE.txt for licensing information

$LOAD_PATH << "client_sample_code"
require 'sample_helper'

if ARGV[0].nil?
  puts "Usage: place_order.rb username\ne.g. place_order.rb rumplestiltskin"
  exit 1
end

# You need to have an account in order to place an order. This script takes
# the username from the command line.
account = magex_post("/account/register", { :username => ARGV[0] }.to_json)

# You need four pieces of data to place an order: 
#   - your secret (so only you can place an order on your behalf)
#   - the commodity code
#   - desired quantity
#   - desired price

order_data_as_json = { 
  :secret => account["secret"], 
  :commodity => :wish,
  :quantity => "50",
  :price => "10"
}.to_json

order = magex_post("/orders/buy", order_data_as_json)

# Once placed, orders are not secure. You can look them up without
# your secret, just with the order id.

if order['id']
  puts "Would show result of query here if it were implemented."
  # magex_get("/order/find/#{order['id']}")
end