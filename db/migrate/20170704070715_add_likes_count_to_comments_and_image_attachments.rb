class AddLikesCountToCommentsAndImageAttachments < ActiveRecord::Migration[5.1]
  def change
    add_column :comments, :likes_count, :integer
    add_column :image_attachments, :likes_count, :integer
  end
end
