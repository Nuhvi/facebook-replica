# frozen_string_literal: true

module UsersHelper
  def avatar_for(user)
    gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}"
    image_tag(gravatar_url, alt: user.first_name, class: 'avatar')
  end

  def name_for(user)
    "<p class = 'name'> #{user.first_name}</p>"
  end
end
