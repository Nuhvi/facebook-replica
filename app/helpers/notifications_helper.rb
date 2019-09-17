# frozen_string_literal: true

module NotificationsHelper
  def notification_action(notification)
    case notification.notifiable_type
    when 'Like' then 'liked your'
    when 'Comment' then 'commented on your'
    when 'HasFriendship::Friendship'
      current_user.friends_with?(notification.notifier) ? 'is now your' : 'sent you a'
    end
  end

  def notifiable_subject_type(notification)
    case notification.notifiable_type
    when 'Like' then notification.notifiable.likeable.class.name
    when 'Comment' then 'Post'
    when 'HasFriendship::Friendship'
      current_user.friends_with?(notification.notifier) ? 'Friend' : 'Friend request'
    end
  end

  def notifiable_path(notification)
    case notification.notifiable_type
    when 'Like' then parent_of_likeable(notification.notifiable.likeable)
    when 'Comment' then notification.notifiable.post
    when 'HasFriendship::Friendship' then notification.notifier
    end
  end

  def parent_of_likeable(likeable)
    likeable.class.name == 'Post' ? likeable : likeable.post
  end
end
