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
      :wish => 0,
      :flyc => 0,
      :sisw => 0,
      :mbns => 0,
      :pixd => 0
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
  
  def add_to_balance(commodity, amount)
    return false if (amount < 0)
    data[:balances][commodity] += amount
    true
  end
  
  def remove_from_balance(commodity, amount)
    return false if (amount < 0 || amount > data[:balances][commodity])
    data[:balances][commodity] -= amount
    true
  end
end


