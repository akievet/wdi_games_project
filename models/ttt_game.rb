class TttGame < ActiveRecord::Base
  has_many :ttt_moves
  belongs_to :player_1, class_name: "User"
  belongs_to :player_2, class_name: "User"
  belongs_to :current_player, class_name: "User"
  belongs_to :invite

  def as_json(options={})
    super(include: [:player_1, :player_2, :current_player])
  end

  def change_player
    if self.current_player == self.player_1
      self.player_2_id
    elsif self.current_player == self.player_2
      self.player_1_id
    end
  end

  def xo
    if self.current_player == self.player_1
      'X'
    elsif self.current_player == self.player_2
      'O'
    end
  end


  def move_valid?

    # Space must be empty
    # Game must still be open
  end

  def moves_array
    moves_array = []
    self.ttt_moves.each do |move|
      letter = move.letter
      space = move.space_id
      moves_array << [ letter, space ]
    end
    return moves_array
  end

end