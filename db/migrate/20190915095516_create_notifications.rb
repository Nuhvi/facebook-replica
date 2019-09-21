# frozen_string_literal: true

class CreateNotifications < ActiveRecord::Migration[5.2]
  def change
    create_table :notifications do |t|
      t.references :notifiable, polymorphic: true
      t.references :user, foreign_key: true
      t.boolean :seen, default: false

      t.timestamps
    end
  end
end
