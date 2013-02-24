# Magex Copyright 2013 Elisabeth Hendrickson
# See LICENSE.txt for licensing information

class Account
  attr :username
  attr :balances
  attr_reader :secret
  
  def initialize(data)
    @username = data["username"]
    @secret = self.class.generate_secret
    @balances = {
      :gold => 1000,
      :wish => 10,
      :flyc => 10,
      :sisw => 10,
      :mbns => 10,
      :pixd => 10
    }
    self
  end
  
  def self.generate_secret
    valid_characters = [('a'..'z'),('A'..'Z'),('0'..'9')].map{|i| i.to_a}.flatten
    (0...50).map{ valid_characters[rand(valid_characters.length)] }.join
  end
  
  def data
    {
      :username => @username,
      :secret => @secret,
      :balances => @balances
    }
  end
  
  def add_to_balance(commodity, quantity)
    return false if (quantity < 0)
    data[:balances][commodity] += quantity
    true
  end
  
  def remove_from_balance(commodity, quantity)
    return false if (quantity < 0 || quantity > @balances[commodity])
    data[:balances][commodity] -= quantity
    true
  end
end


