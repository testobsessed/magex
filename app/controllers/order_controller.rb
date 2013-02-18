# Magex Copyright 2013 Elisabeth Hendrickson
# See LICENSE.txt for licensing information

class MagexServer < Sinatra::Base
  post '/orders/buy' do
    data = verify_submitted_data(request.body.read, Order)
    if data
      new_order = Order.new(data)
      id = @@buy_orders.add(new_order)
      response_data = new_order.data.merge({:order_id => id})
      response = return_success(response_data)
    else
      response = respond_with_error 400, "Data malformed. Please check your syntax."
    end
    deliver_json(response)
  end
  
  # get '/account/status/:secret' do
  #   status response[:code]
  #   response.to_json
  # end
end