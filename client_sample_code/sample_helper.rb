# Magex Copyright 2013 Elisabeth Hendrickson
# See LICENSE.txt for licensing information

require 'rest_client'
require 'json'

# This helper file contains methods to manage the POST and GET requests
# to the Magex server. It uses the rest_client library to make the HTTP
# requests and adds messages that appear on stdout so you can tell
# what is going on. It is intended to provide a reference for how you
# might use the Magex API, but you'll probably want to modify it to
# be less noisy when writing your own client.

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
  begin
    response = RestClient.get("#{@base_uri}#{route}")
  rescue => e
    response = e.response
  end
  response
end

def post_request(route, payload)
  puts "======"
  puts "Posting to #{@base_uri}#{route} with data #{payload}"
  begin
    response = RestClient.post("#{@base_uri}#{route}", payload)
  rescue => e
    response = e.response
  end
  response
end

def display_result(response)
  puts "------"
  puts "Response code: #{response.code}"
  puts "Response body:\n#{JSON.pretty_generate(JSON.parse(response.body))}"
  puts "======"
end