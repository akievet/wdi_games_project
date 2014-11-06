class CreateHangmanGamesTable < ActiveRecord::Migration
  def change
    create_table :hangman_games do |t|
      t.integer :user_id
      t.string :word


      t.timestamps
    end

    add_column :hangman_moves, :user_id, :integer
    add_column :hangman_moves, :hangman_game_id, :integer

  end
end
