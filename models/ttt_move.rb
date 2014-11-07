class TttMove < ActiveRecord::Base
  belongs_to :ttt_game
  belongs_to :user
end