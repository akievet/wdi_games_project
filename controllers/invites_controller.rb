class InvitesController < ApplicationController
  get '/' do
    content_type :json
    user = User.find(current_user.id)
    received_invites= Invite.where(recipient_id: current_user.id)
    sent_invites= Invite.where(sender_id: current_user.id)
    all_invites = Invite.where("recipient_id= ? OR sender_id = ?", current_user.id, current_user.id)

    open_invites= received_invites.where(accepted: false)
    accepted_invites= all_invites.where(accepted: true)
    # change accepted_invites to open games (games where nobody has won yet) organized with newest game on top
    {
      open_invites: open_invites,
      accepted_invites: accepted_invites,
      open_ttt_games: user.open_ttt_games,
      open_hm_games: user.open_hangman_games
      }.to_json
  end
end