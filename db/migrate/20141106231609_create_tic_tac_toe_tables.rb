class CreateTicTacToeTables < ActiveRecord::Migration
  def change
    create_table :ttt_games do |t|
      t.integer :player_1_id
      t.integer :player_2_id

      t.timestamps
    end

    create_table :ttt_moves do |t|
      t.integer :player_id
      t.integer :space_id

      t.timestamps
    end
  end
end
