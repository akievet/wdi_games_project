class TttGame < ActiveRecord::Base
  has_many :ttt_moves
  belongs_to :player_1, class_name: "User"
  belongs_to :player_2, class_name: "User"
  belongs_to :current_player, class_name: "User"
  belongs_to :invite

  def as_json(options={})
    if self.winner
      {
        winner: self.winner
        }.merge super(include: [:player_1, :player_2, :current_player])
    else
      super(include: [:player_1, :player_2, :current_player])
    end
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

  def space_free?(space)
    taken_spaces = self.ttt_moves.map do |move|
      move.space_id
    end
    if taken_spaces.include?(space)
      false
    else
      true
    end
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

  def player_1_move_spaces
    moves = self.ttt_moves.where(user_id: self.player_1_id)
    moves.map do |move|
      move.space_id
    end
  end

  def player_2_move_spaces
    moves = self.ttt_moves.where(user_id: self.player_2_id)
    moves.map do |move|
      move.space_id
    end
  end

  def winner
    winning_combinations = [[0,1,2],[3,4,5],[6,7,8],[0,3,6],[1,4,7],[2,5,8],[6,4,2],[0,4,8]]
    p1_matches = winning_combinations.select do |combo|
      (combo - self.player_1_move_spaces).empty?
    end

    p2_matches = winning_combinations.select do |combo|
      (combo - self.player_2_move_spaces).empty?
    end

    if p1_matches.length > 0
      self.player_1
    elsif p2_matches.length > 0
      self.player_2
    else
      false
    end
  end

  def winner_username
    self.winner.username
  end

  def loser
    loser_array = [self.player_1, self.player_2] - [self.winner]
    loser_array[0]
  end

  def loser_username
    self.loser.username
  end

end