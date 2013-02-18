class MagexServer < Sinatra::Base
  post '/register' do
    parms = JSON.parse(params.to_s)
    username = parms["username"]
    if username.nil?
      status 400
      response = {
        :code => 400,
        :message => "Could not read username. Please check your syntax."
      }
    else
      status 200
      response = Account.new(username).data
    end
    response.to_json
  end
end