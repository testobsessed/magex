# Magex Copyright 2013 Elisabeth Hendrickson
# See LICENSE.txt for licensing information

require 'magex_collection'

class AccountCollection < MagexCollection
  
  def add(account)
    @things[account.secret] = account
  end
  
  def secrets
    @things.keys
  end
  
  def has_user(name)
    @things.map{|key, value| value.data[:username]}.count(name) > 0
  end
  
  def find_from_username(username)
    select({:username => username}).values.first
  end
  
end