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
  attr :parent_id
  attr :children
  
  include JSONChecker  
  @@input_json_shape = {
    "secret" => /^[A-Za-z0-9]{50,}$/,
    "commodity" => RegisteredCommodities.list,
    "quantity" => /^[0-9]+$/,
    "price" => /^[0-9]+$/
  }

  def initialize(data)
    @username = data[:username]
    @commodity = data[:commodity]
    @quantity = data[:quantity].to_i
    @price = data[:price].to_i
    @action = data[:action]
    @status = "open"
    @order_id = MagexServer.next_id
    @parent_id = data[:parent_id] if data.has_key?(:parent_id)
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
  
  def split
    @status = "split"
  end
  
  def open
    @status = "open"
  end
  
  def register_children(order_ids)
    @children = order_ids
  end
  
  def data
    order_fields = {
      :username => @username,
      :commodity => @commodity,
      :quantity => @quantity,
      :price => @price,
      :action => @action,
      :status => @status,
      :order_id => @order_id
    }
    order_fields.merge!({ :children => @children }) if !@children.nil?
    order_fields.merge!({ :parent_id => @parent_id}) if !@parent_id.nil?
    order_fields
  end
end
