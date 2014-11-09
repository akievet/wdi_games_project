class AddGameIdColumnToTttMovesTable < ActiveRecord::Migration
  def change
    add_column :ttt_moves, :game_id, :integer
  end
end
