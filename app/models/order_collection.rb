# Magex Copyright 2013 Elisabeth Hendrickson
# See LICENSE.txt for licensing information

require 'magex_collection'

class OrderCollection < MagexCollection
  def find(number)
    item = nil
    @things.each do |index, order|
      item = order if order.order_id == number
    end
    item
  end
  
  def price_at_least(number)
    return_items = []
    @things.each do |key,value|      
      return_items.push(value) if value.price >= number
    end
    return_items  
  end
  
  def price_at_most(number)
    return_items = []
    @things.each do |key,value|
      return_items.push(value) if value.price <= number
    end
    return_items
  end
  
  def as_hash
    return_hash = {}
    @things.each { |key,value|
      return_hash[key] = value.data
    }
    return_hash
  end
end