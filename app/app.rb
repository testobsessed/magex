# Magex Copyright 2013 Elisabeth Hendrickson
# See LICENSE.txt for licensing information

require 'sinatra'
require 'json'
$LOAD_PATH << "."
$LOAD_PATH << "./app"
$LOAD_PATH << "./app/models"
$LOAD_PATH << "./app/helpers"
$LOAD_PATH << "./app/controllers"
Dir["app/models/*.rb"].each {|file| require file }
Dir["app/controllers/*.rb"].each {|file| require file }
Dir["app/helpers/*.rb"].each {|file| require file }


class MagexServer < Sinatra::Base
  
  set :root, File.dirname(__FILE__)
  set :views, Proc.new { File.join(root, "views") }
  
  before do
    @@accounts ||= AccountCollection.new
    @@buy_orders ||= OrderCollection.new
    @@sell_orders ||= OrderCollection.new
  end
  
  def self.accounts
    @@accounts
  end
  
  def self.buy_orders
    @@buy_orders
  end
  
  def self.sell_orders
    @@sell_orders
  end
  
  def self.reset
    @@accounts = AccountCollection.new
    @@buy_orders = OrderCollection.new
    @@sell_orders = OrderCollection.new
  end
  
  def self.submit_order(action, data)
    account = accounts.find(data["secret"])
    if !account
      response = return_error 400, "User not found. Are you sure you submitted your secret correctly?"
    else
      order_data = {
        "username" => account.username,
        "commodity" => data["commodity"],
        "quantity" => data["quantity"],
        "price" => data["price"],
        "action" => action
      }
      response_data = place_order(order_data)
      response = return_success(response_data)
    end
    puts "MAGEX ABOUT TO DELIVER THE RESPONSE #{response.inspect}"
    response
  end
  
  def self.place_order(data)
    begin
      new_order = Order.new(data)
      if new_order.action == "buy"
        id = @@buy_orders.add(new_order)
      elsif new_order.action == "sell"
        id = @@sell_orders.add(new_order)
      end
      response_data = new_order.data.merge({:order_id => id})
      response_data
    rescue Exception => e
      puts "ERROR! While placing an order: #{e.message}"
    end
  end
  
  get '/' do
    status 200
    haml :main
  end
end

