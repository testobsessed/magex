# Magex Copyright 2013 Elisabeth Hendrickson
# See LICENSE.txt for licensing information

$LOAD_PATH << "client_sample_code"
require 'sample_helper'

# Most of the API calls use JSON. To register an account you
# need JSON with a "username" key. This script uses the ruby
# JSON to_json method to turn a hash into a json string
register_data_as_json = { :username => "unicorn" }.to_json

# This script uses a helper method from the sample_helper.rb file
# See the helper file for implementation details.
account = magex_post("/account/register", register_data_as_json)

# You need the secret in order to query for account status.
# If there was an error in creating the account there will be no secret available.
# The most likely cause of the account not being created with this sample script
# is violating the username uniqueness constraint.
if account['secret']
  magex_get("/account/status/#{account['secret']}")
end