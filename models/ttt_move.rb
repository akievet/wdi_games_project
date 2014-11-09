class TttMove < ActiveRecord::Base
  belongs_to :ttt_game
  belongs_to :player, class_name: "User"

  def letter
    if self.player_id == self.ttt_game.player_1_id
      'X'
    elsif self.player_id == self.ttt_game.player_2_id
      'O'
    end
  end
end