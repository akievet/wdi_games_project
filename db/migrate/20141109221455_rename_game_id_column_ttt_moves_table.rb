class RenameGameIdColumnTttMovesTable < ActiveRecord::Migration
  def change
    rename_column :ttt_moves, :game_id, :ttt_game_id
  end
end
