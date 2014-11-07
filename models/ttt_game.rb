class TttGame < ActiveRecord::Base
  has_many :ttt_moves
  belongs_to :player_1, class_name: "User"
  belongs_to :player_2, class_name: "User"
  belongs_to :invite

  def as_json(options={})
    super(include: [:player_1, :player_2])
  end
end