# Magex Copyright 2013 Elisabeth Hendrickson
# See LICENSE.txt for licensing information

class MagexServer < Sinatra::Base
  post '/orders/buy' do
    payload = request.body.read
    if JSON.is_json?(payload)
      order_data = JSON.parse(payload)
      new_order = Order.new(order_data)
      id = @@buy_orders.add(new_order)
      data = new_order.data.merge({:order_id => id})
      response = return_success(data)
    else
      response = respond_with_error 400, "WHOOPS!"
    end
    deliver_json(response)
  end
  
  # get '/account/status/:secret' do
  #   status response[:code]
  #   response.to_json
  # end
end