# Magex Copyright 2013 Elisabeth Hendrickson
# See LICENSE.txt for licensing information

class MagexServer < Sinatra::Base
  get '/orders/sell' do
    orders_hash = MagexServer.sell_orders.select(params)
    orders_hash.each { |id, order| orders_hash[id] = order.data }
    data = {:orders => orders_hash }
    response = return_success data
    deliver_json(response)
  end
  
  get '/orders/buy' do
    # TODO: this is essentially a duplicate of /orders/sell. Refactor
    orders_hash = MagexServer.buy_orders.select(params)
    orders_hash.each { |id, order| orders_hash[id] = order.data }
    data = {:orders => orders_hash }
    response = return_success data
    deliver_json(response)
  end
  
  post '/orders/buy' do
    submit_order_post("buy", request.body.read)
  end
  
  post '/orders/sell' do
    submit_order_post("sell", request.body.read)
  end
  
  def submit_order_post(action, submitted_data)
    data = verify_submitted_data(submitted_data, Order)
    if data.nil?
      response = return_error 400, "Data malformed. Please check your syntax." 
    else    
      response = MagexServer.submit_order(action, data)
    end
    puts "GOT RESPONSE #{response.inspect}"
    deliver_json(response)
  end

end