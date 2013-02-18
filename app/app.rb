require 'sinatra'
require 'json'
Dir["app/models/*.rb"].each {|file| require file }
Dir["app/controllers/*.rb"].each {|file| require file }


class MagexServer < Sinatra::Base
  
  set :root, File.dirname(__FILE__)
  set :views, Proc.new { File.join(root, "views") }
  
  get '/' do
    status 200
    haml :main
  end
end