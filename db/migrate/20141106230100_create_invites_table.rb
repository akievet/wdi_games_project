class CreateInvitesTable < ActiveRecord::Migration
  def change
    create_table :invites do |t|
      t.text :message, :default => 'Want to play a game of tic tac toe with me?'
      t.integer :sender_id
      t.integer :recipient_id
      t.boolean :accepted, :default => false

      t.timestamps
    end
  end
end
