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
    current_player_id = [invite.recipient_id, invite.sender_id].sample
    game = TttGame.create({player_1_id: invite.sender_id, player_2_id: invite.recipient_id, invite_id: invite.id, current_player_id: current_player_id})
    redirect "/ttt/#{game.id}"
  end

  post '/:id/move' do
    content_type :json
    game = TttGame.find(params[:id])
    space_id = params[:spaceId]

    if current_user == game.current_player
      game.ttt_moves << TttMove.new(player_id: current_user.id, space_id: space_id, ttt_game_id: game.id)
      game.update({current_player_id: game.change_player})
      {
        message: 'Move processed!',
      }.to_json
    else
      {
        message: 'Wait for your turn!',
      }.to_json
    end
  end

  get '/:id/render_board' do
    content_type :json
    game = TttGame.find(params[:id])
    {
      moves_array: game.moves_array,
      current_turn: game.current_player
    }.to_json
  end
end