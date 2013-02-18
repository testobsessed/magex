# Magex Copyright 2013 Elisabeth Hendrickson
# See LICENSE.txt for licensing information

module JSONChecker
  def self.included receiver
    receiver.extend ClassMethods
  end
  
  module ClassMethods
    def expected_json_shape
      self.send :class_variable_get, :@@input_json_shape
    end
    def valid_json?(payload)
      return false unless payload.keys.sort == expected_json_shape.keys.sort
      expected_json_shape.each do |key, value|
        if value.class == Regexp
          return false if !payload[key].match value
        elsif value.class == Array
          return false if !value.include? payload[key]
        end
      end
      true
    end

  end
end