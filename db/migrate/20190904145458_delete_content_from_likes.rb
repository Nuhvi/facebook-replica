class DeleteContentFromLikes < ActiveRecord::Migration[5.2]
  def change
    remove_column :likes, :content
  end
end
