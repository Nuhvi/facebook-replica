# frozen_string_literal: true

module PostsHelper
  def show_path?
    request.fullpath.match(%r{posts/\d+})
  end
end
