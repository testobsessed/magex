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
  
  def select(method, criteria)
    puts "IN SELECT WITH #{method}, #{criteria}. METHOD is a #{method.class}"
    return_items = {}
    @things.each do |key,value| 
      return_items[key] = value if value.send(method) == criteria
    end
    puts "RETURNING WITH #{return_items}"
    return_items
  end

end