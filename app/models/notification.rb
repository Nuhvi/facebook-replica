class Notification < ApplicationRecord
  belongs_to :notifiable, polymorphic: true
  belongs_to :user

  default_scope { order(updated_at: :desc) }

end
