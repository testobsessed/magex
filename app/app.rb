# Magex Copyright 2013 Elisabeth Hendrickson
# See LICENSE.txt for licensing information

require 'sinatra'
require 'json'
Dir["app/models/*.rb"].each {|file| require file }
Dir["app/controllers/*.rb"].each {|file| require file }
Dir["app/helpers/*.rb"].each {|file| require file }


class MagexServer < Sinatra::Base
  
  set :root, File.dirname(__FILE__)
  set :views, Proc.new { File.join(root, "views") }
  
  before do
    @@accounts ||= AccountCollection.new
  end
  
  def self.accounts
    @@accounts
  end
  
  get '/' do
    status 200
    haml :main
  end
end

