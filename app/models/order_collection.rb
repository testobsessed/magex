# Magex Copyright 2013 Elisabeth Hendrickson
# See LICENSE.txt for licensing information

require 'magex_collection'

class OrderCollection < MagexCollection
  def add(order)
    @things[order.order_id] = order
  end
end