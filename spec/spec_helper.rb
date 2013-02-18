require 'rubygems'
require 'rspec'
require 'rack/test'
$LOAD_PATH << "."
$LOAD_PATH << "./app"

require 'app'
Dir["app/models/*.rb"].each {|file| require file }

set :environment, :test

def app
  MagexServer
end

RSpec.configure do |conf|
  conf.include Rack::Test::Methods
end
