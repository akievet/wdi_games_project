class ChangePlayerIdColumnNameToUserIdInTttMovesColumn < ActiveRecord::Migration
  def change
    rename_column :ttt_moves, :player_id, :user_id
  end
end
