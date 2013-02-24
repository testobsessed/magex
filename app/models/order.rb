# Magex Copyright 2013 Elisabeth Hendrickson
# See LICENSE.txt for licensing information

require 'json_checker'
require 'registered_commodities'

class Order
  attr :username
  attr :commodity
  attr :quantity
  attr :price
  attr :status
  attr :action
  attr :order_id
  
  include JSONChecker  
  @@input_json_shape = {
    "secret" => /^[A-Za-z0-9]{50,}$/,
    "commodity" => RegisteredCommodities.list,
    "quantity" => /^[0-9]+$/,
    "price" => /^[0-9]+$/
  }

  def initialize(data)
    @username = data["username"]
    @commodity = data["commodity"]
    @quantity = data["quantity"]
    @price = data["price"]
    @action = data["action"]
    @status = "open"
    @order_id = MagexServer.next_id
  end
  
  def buy?
    @action == "buy"
  end
  
  def sell?
    @action == "sell"
  end
  
  def in_escrow
    @status = "escrow"
  end
  
  def completed
    @status = "completed"
  end
  
  def open
    @status = "open"
  end
  
  def data
    {
      :username => @username,
      :commodity => @commodity,
      :quantity => @quantity,
      :price => @price,
      :action => @action,
      :status => @status,
      :order_id => @order_id
    }
  end
end
