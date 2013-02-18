require 'rest_client'
require 'json'

@base_uri = "http://localhost:9292"

def magex_post(route, payload)
  response = post_request(route, payload)
  display_result(response)
  JSON.parse(response.body)
end

def magex_get(route)
  response = get_request(route)
  display_result(response)
  JSON.parse(response.body)
end

def get_request(route)
  puts "======"
  puts "Getting #{@base_uri}#{route}"
  RestClient.get("#{@base_uri}#{route}")
end

def post_request(route, payload)
  puts "======"
  puts "Posting to #{@base_uri}#{route} with data #{payload}"
  RestClient.post("#{@base_uri}#{route}", payload)
end

def display_result(response)
  puts "------"
  puts "Response code: #{response.code}"
  puts "Response body:\n#{JSON.pretty_generate(JSON.parse(response.body))}"
  puts "======"
end