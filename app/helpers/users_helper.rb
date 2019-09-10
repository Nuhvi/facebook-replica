# frozen_string_literal: true

module UsersHelper
  def avatar_for(user)
    gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}"
    image = image_tag(gravatar_url, alt: user.first_name)
    ("<a href='#{user_path(user)}' class='avatar'>#{image}</a>").html_safe
  end

  def name_for(user)
    ("<a href='#{user_path(user)}' class='username'> #{user.first_name + " " + user.last_name} </a>").html_safe
  end
end
