# frozen_string_literal: true

module PostsHelper
  def is_show
    request.fullpath.match(/posts\/\d+/)
  end
end
