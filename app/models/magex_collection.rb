# Magex Copyright 2013 Elisabeth Hendrickson
# See LICENSE.txt for licensing information

class MagexCollection
  attr :things
  
  def initialize
    @things = {}
  end
  
  def add(thing)
    id = count + 1
    @things[id] = thing
    id
  end
  
  def count
    @things.length
  end
  
  def find(id)
    @things[id]
  end
  
  def delete(id)
    @things.delete(id)
  end
  
  def values
    @things.values
  end
  
  def select(criteria)
    return_items = self.class.new
    @things.each do |key,value|
      meets_criteria = true
      criteria.each do |method, criterion|
        meets_criteria &= (value.send(method) == criterion)
      end
      return_items.add(value) if meets_criteria
    end
    return_items
  end

end