# Magex Copyright 2013 Elisabeth Hendrickson
# See LICENSE.txt for licensing information

class MagexServer < Sinatra::Base
  post '/orders/buy' do
    submit_order_post("buy", request.body.read)
  end
  
  post '/orders/sell' do
    submit_order_post("sell", request.body.read)
  end
  
  def submit_order_post(action, submitted_data)
    data = verify_submitted_data(submitted_data, Order)
    if !data
      response = respond_with_error 400, "Data malformed. Please check your syntax." 
    else
      account = @@accounts.find(data["secret"])
      if !account
        response = respond_with_error 400, "User not found. Are you sure you submitted your secret correctly?"
      else
        response_data = place_order({
          "username" => account.username,
          "commodity" => data["commodity"],
          "quantity" => data["quantity"],
          "price" => data["price"],
          "action" => action
        })
        response = return_success(response_data)
      end      
    end
    deliver_json(response)
  end

end