class HangmanMove < ActiveRecord::Base
  belongs_to :hangman_game
  belongs_to :user

  def is_correct?
    word= self.hangman_game.word

    word.chars.include? self.letter
  end

end