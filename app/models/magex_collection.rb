# Magex Copyright 2013 Elisabeth Hendrickson
# See LICENSE.txt for licensing information

class MagexCollection
  attr :things
  
  def initialize
    @things = {}
  end
  
  def add(thing)
    thing_id = MagexServer.next_id
    @things[thing_id] = thing
    thing_id
  end
  
  def count
    @things.length
  end
  
  def find(thing_id)
    @things[thing_id]
  end
  
  def delete(thing_id)
    @things.delete(thing_id)
  end
  
  def values
    @things.values
  end
  
  def get_index_for(thing)
    index = nil
    @things.each do |key,stored_thing|
      index = key if thing == stored_thing
    end
    index
  end
  
  def move_to_end(thing)
    thing_id = get_index_for(thing)
    @things.delete(thing_id)
    add(thing)
  end
  
  def select(criteria)
    return self if criteria.nil?
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
  
  def last
    @things[max_key]
  end
  
  def max_key
    @things.keys.max
  end
    
end