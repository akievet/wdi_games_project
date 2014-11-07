class TttController < ApplicationController
  get '/' do
    authenticate!
    erb :'ttt/index'
  end

  get '/setup' do
    #User selects 'multiplayer' then has to search for a user to invite to play with them
    #User can also play against the computer
    erb :'ttt/setup'
  end

  get '/search_users' do
    query= params[:query].downcase || 'a'
    users = User.where("LOWER(username) LIKE?", "%#{query}%").limit(100) || User.where("LOWER(email) LIKE?", "%#{query}%").limit(100)
    users.to_json
  end
end