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
  
  def split_order(order, quantity)
    order.split
    remainder = order.quantity - quantity
    split_data_a = order.data.merge({:quantity => quantity, :parent_id => order.order_id})
    split_data_b = order.data.merge({:quantity => remainder, :parent_id => order.order_id})
    split_a = Order.new(split_data_a)
    split_b = Order.new(split_data_b)
    order.register_children([split_a.order_id, split_b.order_id])
    add(split_a)
    add(split_b)
    split_a
  end
end