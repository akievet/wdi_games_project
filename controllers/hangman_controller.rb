class HangmanController < ApplicationController

  get '/:id' do
    authenticate!
    @game= HangmanGame.find(params[:id])
    @blanks = @game.show_correct_letters
    @correct = @game.correct_letters ||= []
    @incorrect = @game.incorrect_letters ||= []

    erb :'hangman/index'
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

      game.hangman_moves << HangmanMove.new(letter: letter, user_id: current_user.id)

      if game.correct?
        {
         win: true,
         score: game.lives
        }.to_json

      elsif game.another_turn?
        {
          secret_word: game.show_correct_letters,
          correct_letters: game.correct_letters ||= [],
          incorrect_letters: game.incorrect_letters ||= [],
          score: game.lives
        }.to_json

      else
        {
          lose: true,
          revealed_word: game.word
        }.to_json
      end

    end
  end

  post '/:id/word' do
    content_type :json
    game = HangmanGame.find(params[:id])
    answer= params[:wordGuess].downcase

    game.guess_entire_word(answer)

    if game.correct?
      {
        win: true,
        score: game.lives
      }.to_json

    elsif game.another_turn?
      {
        secret_word: game.show_correct_letters,
        correct_letters: game.correct_letters ||= [],
        incorrect_letters: game.incorrect_letters ||= [],
        score: game.lives
      }.to_json

    else
      {
        lose: true,
        revealed_word: game.word
      }.to_json
    end

  end

  get '/:id/win' do
    @game = HangmanGame.find(params[:id])
    erb :'hangman/win'
  end

  get '/:id/lose' do
    erb :'hangman/lose'
  end


end
