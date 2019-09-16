# frozen_string_literal: true

module NotificationsHelper
  def notification_action(notification)
    case notification.notifiable_type
    when 'Like' then 'liked your'
    when 'Comment' then 'commented on your'
    when 'Friendship' then current_user.friend?(notification.notifier) ? 'accepted your' : 'sent you'
    end
  end

  def notifiable_subject_type(notification)
    case notification.notifiable_type
    when 'Like' then notification.notifiable.likeable.class.name
    when 'Comment' then 'Post'
    when 'Friendship' then 'Friend request'
    end
  end

  def notifiable_path(notification)
    case notification.notifiable_type
    when 'Like' then parent_of_likeable(notification.notifiable.likeable)
    when 'Comment' then notification.notifiable.post
    when 'Friendship' then notification.notifier
    end
  end

  def parent_of_likeable(likeable)
    likeable.class.name == 'Post' ? likeable : likeable.post
  end
end
