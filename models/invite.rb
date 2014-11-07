class Invite < ActiveRecord::Base
  belongs_to :sender, class_name: "User"
  belongs_to :recipient, class_name: "User"

  def as_json(options={})
   super(include: [:sender, :recipient])
  end
end