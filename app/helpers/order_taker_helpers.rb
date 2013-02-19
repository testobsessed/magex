# Magex Copyright 2013 Elisabeth Hendrickson
# See LICENSE.txt for licensing information

require 'order'

def place_order(data)
  begin
    new_order = Order.new(data)
    id = MagexServer.place_order(new_order)
    response_data = new_order.data.merge({:order_id => id})
    response_data
  rescue Exception => e
    puts "ERROR! While placing an order: #{e.message}"
  end
end