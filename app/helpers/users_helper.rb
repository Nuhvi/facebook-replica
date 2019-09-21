# frozen_string_literal: true

module UsersHelper
  def avatar_for(user)
    gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}"
    profile_image = user.profile_image || gravatar_url
    image = image_tag(profile_image, alt: user.full_name)
    "<a href='#{user_path(user)}' class='avatar'>#{image}</a>".html_safe
  end

  def name_for(user)
    "<a href='#{user_path(user)}' class='username'> #{user.full_name} </a>".html_safe
  end
end
