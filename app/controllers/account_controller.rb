class MagexServer < Sinatra::Base
  post '/register' do
    username = nil
    data = JSON.parse(request.body.read)
    username = data["username"]
    if username.nil?
      status 400
      response = {
        :code => 400,
        :message => "Could not read username. Please check your syntax."
      }
    else
      status 200
      response = Account.new(data).data
    end
    response.to_json
  end
end