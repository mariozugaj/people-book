class AddSlugsToModels < ActiveRecord::Migration[5.1]
  def change
    add_column :status_updates, :slug, :string, unique: true
    add_column :photo_albums, :slug, :string, unique: true
    add_column :images, :slug, :string, unique: true
    add_column :conversations, :slug, :string, unique: true
    add_column :likes, :slug, :string, unique: true
    add_column :comments, :slug, :string, unique: true
    add_column :friendships, :slug, :string, unique: true
    add_column :notifications, :slug, :string, unique: true
    add_column :profiles, :slug, :string, unique: true
    add_column :messages, :slug, :string, unique: true
  end
end
