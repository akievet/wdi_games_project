class UsersController < ApplicationController
  get '/new' do
    erb :'users/new'
  end

  post '/' do
    user = User.new(params[:user])
    user.password = params[:password]
    user.save!
    redirect '/'
  end

  get '/:id' do
    @user = User.find(params[:id])
    erb :'users/show'
  end

  get '/:id/scores' do
    user = User.find(params[:id])
    content_type :json
    {
      hangman_games: user.hangman_games,
      ttt_games: user.ttt_games
    }.to_json
  end
end