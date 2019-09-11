# frozen_string_literal: true

module LikesHelper
  def likeable_data(likeable)
    { like: { likeable_id: likeable.id, likeable_type: likeable.class.name } }
  end
end
