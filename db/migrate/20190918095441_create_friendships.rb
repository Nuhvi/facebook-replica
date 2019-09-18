# frozen_string_literal: true

class CreateFriendships < ActiveRecord::Migration[5.2]
  def change
    create_table :friendships do |t|
      t.references :user, index: true, foreign_key: true
      t.references :friend, index: true, foreign_key: { to_table: 'users' }
      t.integer :status
    end

    add_index :friendships, %i[user_id friend_id], unique: true
  end
end
