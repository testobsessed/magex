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

  def self.accounts
    @@accounts ||= AccountCollection.new
  end
  
  def self.buy_orders
    @@buy_orders ||= OrderCollection.new
  end
  
  def self.sell_orders
    @@sell_orders ||= OrderCollection.new
  end
  
  def self.next_id
    @@id_counter ||= 0
    @@id_counter += 1
  end
  
  def self.reset
    @@accounts = AccountCollection.new
    @@buy_orders = OrderCollection.new
    @@sell_orders = OrderCollection.new
  end
  
  def self.get_username_from_secret(secret)
    accounts.find(secret).username
  end
  
  def self.submit_order(order)
    post_order(order)
  end
  
  def self.post_order(order)
    if order.action == "buy"
      @@buy_orders.add(order)
    elsif order.action == "sell"
      @@sell_orders.add(order)
    end
  end
  
  get '/' do
    status 200
    haml :main
  end
end

