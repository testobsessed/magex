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
end