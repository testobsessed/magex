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
    @type = data["type"]
    @status = "open"
  end
  
  def data
    {
      :username => @username,
      :commodity => @commodity,
      :quantity => @quantity,
      :price => @price,
      :type => @type,
      :status => @status
    }
  end
end
