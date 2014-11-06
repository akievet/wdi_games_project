class CreateHangmanMovesTable < ActiveRecord::Migration
  def change
    create_table :hangman_moves do |t|
      t.string :letter

      t.timestamps
    end
  end
end
