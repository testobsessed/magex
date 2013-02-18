# Magex Copyright 2013 Elisabeth Hendrickson
# See LICENSE.txt for licensing information

require 'json'

module JSON
  def self.is_json?(payload)
    retval = true
    begin
      parse(payload).all?
    rescue ParserError
      retval = retval && false
    end
    retval
  end
end
