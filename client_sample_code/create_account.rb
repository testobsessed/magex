$LOAD_PATH << "."
$LOAD_PATH << "client_sample_code"
require 'sample_helper'

magex_post("/account/register", { :username => "unicorn" }.to_json)