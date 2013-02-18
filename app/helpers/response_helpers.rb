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