# Magex Copyright 2013 Elisabeth Hendrickson
# See LICENSE.txt for licensing information

require 'rest_client'
require 'json'

class MagexClient
  
  attr :base_url
  attr :secret
  attr :username
  
  def initialize(name, url)
    @username = name
    @base_url = url
    @secret = register(name)
    if @secret.nil?
      raise "ERROR! Failed to register name #{name}."
    end
  end
  
  def register(name)
    response = magex_post(endpoints[:register], { :username => name }.to_json)
    if response["code"] == 200
      return response["secret"]
    else
      return nil
    end
  end
  
  def buy(commodity, quantity, price)
    post_order(:buy, commodity, quantity, price)
  end
  
  def sell(commodity, quantity, price)
    post_order(:sell, commodity, quantity, price)
  end
  
  def balances
    response = {}
    full_status = magex_get(endpoints[:status])
    full_status["balances"].each { |key,value| response[key.to_sym] = value }
    response
  end
  
  def open_buy_orders(commodity = nil)
    url = endpoints[:open_buy_orders]
    url = "#{url}&commodity=#{commodity}" if !commodity.nil?
    get_orders_from(url)
  end
  
  def open_sell_orders(commodity = nil)
    url = endpoints[:open_sell_orders]
    url = "#{url}&commodity=#{commodity}" if !commodity.nil?
    get_orders_from(url)
  end
    
  def endpoints
    {
      :register => "/account/register",
      :buy => "/orders/buy",
      :sell => "/orders/sell",
      :open_buy_orders => "/orders/buy?status=open&username=#{@username}",
      :open_sell_orders => "/orders/sell?status=open&username=#{@username}",
      :status => "/account/status/#{@secret}"
    }
  end
  
  private
  def magex_post(route, payload)
    begin
      response = RestClient.post("#{@base_url}#{route}", payload)
    rescue => e
      response = e.response
    end
    JSON.parse(response.body)
  end
  
  def magex_get(route)
    begin
      response = RestClient.get("#{@base_url}#{route}")
    rescue => e
      response = e.response
    end
    JSON.parse(response.body)
  end
  
  def post_order(type, commodity, quantity, price)
    order_data = {
      :secret => @secret, 
      :commodity => commodity,
      :quantity => quantity,
      :price => price
    }.to_json
    magex_post(endpoints[type], order_data)
  end
  
  def get_orders_from(url)
    response = []
    full_orders = magex_get(url)
    full_orders["orders"].each do |order_id, order_data|
      response.push({
        :commodity => order_data["commodity"].to_sym,
        :price => order_data["price"],
        :quantity => order_data["quantity"]
      })
    end
    response
  end
  
end