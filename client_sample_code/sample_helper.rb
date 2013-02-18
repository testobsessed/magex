require 'rest_client'
require 'json'

@base_uri = "http://localhost:9292"

def magex_post(route, payload)
  puts "======"
  puts "Posting to #{@base_uri}#{route} with data #{payload}"
  response = RestClient.post("#{@base_uri}#{route}", payload)
  puts "------"
  puts "Response code: #{response.code}"
  puts "Response body:\n#{JSON.pretty_generate(JSON.parse(response.body))}"
  puts "======"
end