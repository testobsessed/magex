# Magex Copyright 2013 Elisabeth Hendrickson
# See LICENSE.txt for licensing information

class EscrowAccount
  attr :buyer_order_id
  attr :seller_order_id
  attr :buyer
  attr :seller
  attr :payment_received
  attr :commodity_received
  
  def initialize(buyer_order, seller_order)
  end
  
  def collect_buyer_funds
  end
  
  def collect_seller_goods
  end
  
  def buyer_funded?
  end
  
  def seller_funded?
  end
  
end