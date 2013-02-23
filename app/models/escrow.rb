# Magex Copyright 2013 Elisabeth Hendrickson
# See LICENSE.txt for licensing information

class EscrowAccount
  attr :buy_order
  attr :sell_order
  attr :buyer
  attr :seller
  attr :escrow_commodity
  attr :escrow_commodity_quantity
  attr :escrow_gold
  attr :payment_received
  attr :commodity_received
  
  def initialize(buy_order, sell_order)
    buy_order.in_escrow
    sell_order.in_escrow
    @escrow_commodity = buy_order.commodity.to_sym
    @escrow_commodity_quantity = buy_order.quantity
    @escrow_gold = (sell_order.price * @escrow_commodity_quantity)
    @buy_order = buy_order    
    @sell_order = sell_order
    @buyer = MagexServer.accounts.find_from_username(buy_order.username)
    @seller = MagexServer.accounts.find_from_username(sell_order.username)
    @payment_received = false
    @commodity_received = false
  end
  
  def collect_buyer_funds
    @payment_received = @buyer.remove_from_balance(:gold, @escrow_gold)
  end
  
  def collect_seller_goods
    @commodity_received = @seller.remove_from_balance(@escrow_commodity, @escrow_commodity_quantity)
  end
  
  def complete_transaction
    @buyer.add_to_balance(@escrow_commodity, @escrow_commodity_quantity)
    @seller.add_to_balance(:gold, @escrow_gold)
    @buy_order.completed
    @sell_order.completed
    {
      :buyer => @buyer.username,
      :seller => @seller.username,
      :commodity => @escrow_commodity,
      :quantity => @escrow_commodity_quantity,
      :price => @sell_order.price
    }
  end
  
  def buyer_funded?
    @payment_received
  end
  
  def seller_funded?
    @commodity_received
  end
  
  def complete?
    buyer_funded? && seller_funded?
  end
end