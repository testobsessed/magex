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
  
  def self.place_order(new_order)
    if new_order.action == "buy"
      @@buy_orders.add(new_order)
    elsif new_order.action == "sell"
      @@sell_orders.add(new_order)
    end
  end
  
  get '/' do
    status 200
    haml :main
  end
end

