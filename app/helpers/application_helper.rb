# frozen_string_literal: true

module ApplicationHelper
  def full_title(page_title = '')
    base_title = 'Fakebook'
    page_title.empty? ? base_title : page_title + ' | ' + base_title
  end

  def alert_type(message_type)
    if message_type == 'notice'
      'success'
    elsif message_type == 'alert'
      'danger'
    end
  end

  def edit_path?
    request.fullpath.match(%r{\d+/edit})
  end
end
