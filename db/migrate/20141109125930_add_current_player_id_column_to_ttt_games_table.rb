class AddCurrentPlayerIdColumnToTttGamesTable < ActiveRecord::Migration
  def change
    add_column :ttt_games, :current_player_id, :integer
  end
end
