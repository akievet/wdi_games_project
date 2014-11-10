class TttMove < ActiveRecord::Base
  belongs_to :ttt_game
  belongs_to :user

  def letter
    if self.user_id == self.ttt_game.player_1_id
      'X'
    elsif self.user_id == self.ttt_game.player_2_id
      'O'
    end
  end
end