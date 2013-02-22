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
    if match_available?(order)
      do_transaction(order)
    else  
      post_order(order)
    end
  end
  
  def self.add_to_account(user, commodity, amount)
    commodity = commodity.to_sym if commodity.class == String
    user.add_to_balance(commodity, amount)
  end
  
  def self.remove_from_account(user, commodity, amount)
    commodity = commodity.to_sym if commodity.class == String
    user.remove_from_balance(commodity, amount)
  end
  
  def self.do_transaction(order)
    #raise "make all the tests fail"
  end
  
  def self.match_available?(order)
    if order.sell?
      matches = buyers(order)
    else
      matches = sellers(order)
    end
    return matches.count > 0
  end
  
  def self.buyers(order)
    potential_buyers = buy_orders.price_at_least(order.price)
    potential_buyers.sort! { |a, b| [-a.price, a.order_id] <=> [-b.price, b.order_id] }
  end
  
  def self.sellers(order)
    potential_sellers = sell_orders.price_at_most(order.price)
    potential_sellers.sort! { |a, b| [a.price, a.order_id] <=> [b.price, b.order_id] }
  end
  
  def self.post_order(order)
    if order.buy?
      buy_orders.add(order)
    elsif order.sell?
      sell_orders.add(order)
    end
  end
  
  get '/' do
    status 200
    haml :main
  end
end

