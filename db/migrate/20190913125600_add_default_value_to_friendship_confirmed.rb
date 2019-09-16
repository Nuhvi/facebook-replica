# frozen_string_literal: true

class AddDefaultValueToFriendshipConfirmed < ActiveRecord::Migration[5.2]
  def up
    change_column_default :friendships, :confirmed, false
  end
end
