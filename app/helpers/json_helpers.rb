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
