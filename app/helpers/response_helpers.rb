# Magex Copyright 2013 Elisabeth Hendrickson
# See LICENSE.txt for licensing information

require 'json'

def return_error(code, message)
  {
    :code => code,
    :message => message
  }
end

def return_success(payload)
  {
    :code => 200,
  }.merge(payload)
end

def deliver_json(response)
  content_type :json
  status response[:code]
  response.to_json
end

def verify_submitted_data(payload, klass)
  return nil if !JSON.is_json?(payload)
  data_as_json = JSON.parse(payload)
  response = klass.valid_json?(data_as_json)
  return nil if !klass.valid_json?(data_as_json)
  data_as_json.keys.each do |key|
    data_as_json[key.to_sym] = data_as_json[key]
    data_as_json.delete(key)
  end
  return data_as_json
end