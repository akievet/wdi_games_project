class HangmanController < ApplicationController

  get '/:id' do
    authenticate!
    @game= HangmanGame.find(params[:id])

    if @game.correct?
      redirect "/hangman/#{@game.id}/win"
    elsif @game.another_turn?
      @game = HangmanGame.find(params[:id])
      @blanks = @game.show_correct_letters
      @correct = @game.correct_letters ||= []
      @incorrect = @game.incorrect_letters ||= []
      erb :'hangman/index'
    else
      redirect "/hangman/#{@game.id}/lose"
    end
  end


  post '/' do
    authenticate!
    game = HangmanGame.new({user_id: current_user.id})
    game.word = game.secret_word
    game.save!
    redirect "/hangman/#{game.id}"
  end

  post '/:id/guess' do
    content_type :json
    game = HangmanGame.find(params[:id])
    letter = params[:letterGuess].downcase

    if game.guess_not_valid?(letter)
      { message: 'The eight-ball says, try again later'}.to_json
    else
      #move = HangmanMove.create({letter: letter, user_id: current_user.id, hangman_game_id: game.id})
      game.hangman_moves << HangmanMove.new(letter: letter, user_id: current_user.id)

      {
        secret_word: game.show_correct_letters,
        correct_letters: game.correct_letters ||= [],
        incorrect_letters: game.incorrect_letters ||= [],
        score: game.lives
      }.to_json
    end


  end

  post '/:id/word' do
    content_type :json
    game = HangmanGame.find(params[:id])
    answer= params[:wordGuess].downcase

    game.guess_entire_word(answer)

    {
      secret_word: game.show_correct_letters,
      correct_letters: game.correct_letters ||= [],
      incorrect_letters: game.incorrect_letters ||= [],
      score: game.lives
    }.to_json
  end

  get '/:id/win' do
    @game = HangmanGame.find(params[:id])
    erb :'hangman/win'
  end

  get '/:id/lose' do
    erb :'hangman/lose'
  end


end
