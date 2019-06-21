class NotificationsController < ApplicationController
  def index
    @invitations = current_user.invitations
                               .includes(project: :owner)
                               .order(id: :desc)
                               .page(params[:page])
  end
end
