class TttController < ApplicationController
  get '/' do
    authenticate!
    erb :'ttt/index'
  end

  get '/search_users' do
    query = params[:query].downcase || 'a'
    users = User.where("LOWER(username) LIKE?", "%#{query}%").limit(100) || User.where("LOWER(email) LIKE?", "%#{query}%").limit(100)
    users.to_json
  end

  post '/invite' do
    content_type :json
    invite = Invite.create({sender_id: current_user.id, recipient_id: params[:id]})
    name = User.find(params[:id]).username
    {
      name: name
    }.to_json
  end

  get '/:id' do
    @game= TttGame.find(params[:id])

    erb :'ttt/show'
  end

  post '/new' do
    invite = Invite.find(params[:id])
    invite.update({accepted: true, message: 'Invitation Accepted: Go to game'})
    game = TttGame.create({player_1_id: invite.sender_id, player_2_id: invite.recipient_id, invite_id: invite.id})
    redirect "/ttt/#{game.id}"
  end
end