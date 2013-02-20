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
    order_data = verify_submitted_data(submitted_data, Order)
    if order_data.nil?
      response = return_error 400, "Data malformed. Please check your syntax." 
    else
      order_data.merge!({ "action" => action })
      username = MagexServer.get_username_from_secret(order_data.delete("secret"))
      if !username
        response = return_error 400, "User not found. Are you sure you submitted your secret correctly?"
      else
        order_data.merge!({ "username" => username })
        order = Order.new(order_data)
        MagexServer.submit_order(order)
        response = return_success(order.data)
      end
    end
    deliver_json(response)
  end

end