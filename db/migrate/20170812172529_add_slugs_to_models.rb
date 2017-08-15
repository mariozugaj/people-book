class AddSlugsToModels < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :slug, :string, unique: true
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
    add_index :users, :slug
    add_index :status_updates, :slug
    add_index :photo_albums, :slug
    add_index :images, :slug
    add_index :conversations, :slug
    add_index :likes, :slug
    add_index :comments, :slug
    add_index :friendships, :slug
    add_index :notifications, :slug
    add_index :profiles, :slug
    add_index :messages, :slug
  end
end
