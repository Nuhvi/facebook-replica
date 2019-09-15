class NotificationsController < ApplicationController
  before_action :authenticate_user!
  after_action :see_all_notifs

  def index
    @unseen = current_user.unseen_notifs
    @seen = current_user.seen_notifs
  end

  def see_all_notifs
    current_user.see_all_notifs
  end
end
