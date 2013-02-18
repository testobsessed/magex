# Magex Copyright 2013 Elisabeth Hendrickson
# See LICENSE.txt for licensing information

class Order
  attr :username
  attr :commodity
  attr :quantity
  attr :price
  attr :status
  
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
