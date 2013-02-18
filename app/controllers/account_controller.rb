class MagexServer < Sinatra::Base
  post '/account/register' do
    payload = request.body.read
    username = nil
    if JSON.is_json?(payload)
      data = JSON.parse(payload)
      username = data["username"]
    end
    if username.nil?
      status 400
      response = {
        :code => 400,
        :message => "Could not read username. Please check your syntax."
      }
    else
      status 200
      new_account = Account.new(data)
      @@accounts.add(new_account)
      response = new_account.data
    end
    response.to_json
  end
  
  get '/account/status/:secret' do
    account = MagexServer.accounts.find(params[:secret])
    if account
      status 200
      response = account.data
    else
      status 404
      response = {
        :code => 404,
        :message => "Could not find account. Are you sure you have the right secret?"
      }
    end
    response.to_json
  end
end