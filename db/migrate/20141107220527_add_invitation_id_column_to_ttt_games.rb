class AddInvitationIdColumnToTttGames < ActiveRecord::Migration
  def change
    add_column :ttt_games, :invite_id, :integer, default: nil
  end
end
