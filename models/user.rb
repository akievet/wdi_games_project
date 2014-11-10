class User < ActiveRecord::Base
  include BCrypt
  has_many :hangman_games
  has_many :hangman_moves
  has_many :ttt_moves

  def password
    @password ||= Password.new(self.password_hash)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_hash = @password
  end

  def ttt_games
    TttGame.where("player_1_id = ? OR player_2_id = ?", self.id, self.id )
  end

  def open_ttt_games
    ttt = self.ttt_games
    ttt = ttt.select { |game| game.winner == false }
  end

  def open_hangman_games
    hangman = self.hangman_games
    hangman = hangman.select { |game| game.correct? == false }
  end

  def open_games
    self.open_ttt_games + self.open_hangman_games
  end

  def closed_hm_games
    self.hangman_games - self.open_hangman_games
  end

  def closed_ttt_games
    self.ttt_games - self.open_ttt_games
  end
end