# Magex Copyright 2013 Elisabeth Hendrickson
# See LICENSE.txt for licensing information

class MagexServer < Sinatra::Base
  post '/account/register' do
    payload = request.body.read
    username = nil
    if JSON.is_json?(payload)
      data = JSON.parse(payload)
      username = data["username"]
    end
    if username.nil?
      response = return_error 400, "Could not read username. Please check your syntax."
    elsif MagexServer.accounts.has_user(username)
      response = return_error 409, "Username already taken. Please try to register again."
    else
      new_account = Account.new(data)
      @@accounts.add(new_account)
      response = return_success new_account.data
    end
    deliver_json(response)
  end
  
  get '/account/status/:secret' do
    account = MagexServer.accounts.find(params[:secret])
    if account
      response = return_success account.data
    else
      response = return_error 404, "Could not find account. Are you sure you have the right secret?"
    end
    deliver_json(response)
  end
end