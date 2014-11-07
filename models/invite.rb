class Invite < ActiveRecord::Base
  belongs_to :sender, class_name: "User"
  belongs_to :recipient, class_name: "User"
  has_one :ttt_game

  def as_json(options={})
   super(include: [:sender, :recipient, :ttt_game])
  end
end