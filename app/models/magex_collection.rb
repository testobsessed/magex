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
end