# Magex Copyright 2013 Elisabeth Hendrickson
# See LICENSE.txt for licensing information

class MagexServer < Sinatra::Base
  get '/market/valuations' do
    data = MagexServer.market_valuations
    response = return_success data
    deliver_json(response)
  end
end