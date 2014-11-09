class InvitesController < ApplicationController
  get '/' do
    content_type :json
    received_invites= Invite.where(recipient_id: current_user.id)
    sent_invites= Invite.where(sender_id: current_user.id)
    all_invites = Invite.where("recipient_id= ? OR sender_id = ?", current_user.id, current_user.id)

    open_invites= received_invites.where(accepted: false)
    accepted_invites= all_invites.where(accepted: true)

    {
      open_invites: open_invites,
      accepted_invites: accepted_invites
      }.to_json
  end
end