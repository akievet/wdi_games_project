class InvitesController < ApplicationController
  get '/' do
    content_type :json
    invites= Invite.where(recipient_id: current_user.id)
    open_invites= invites.where(accepted: false)
    {open_invites: open_invites}.to_json
  end
end