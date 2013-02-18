# Magex Copyright 2013 Elisabeth Hendrickson
# See LICENSE.txt for licensing information

class AccountCollection
  attr :accounts
  
  def initialize
    @accounts = {}
  end
  
  def add(account)
    @accounts[account.secret] = account
  end
  
  def count
    @accounts.length
  end
  
  def find(secret)
    @accounts[secret]
  end
  
  def secrets
    @accounts.keys
  end
  
  def has_user(name)
    @accounts.map{|key, value| value.data[:username]}.count(name) > 0
  end
end