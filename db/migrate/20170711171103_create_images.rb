# frozen_string_literal: true

class CreateImages < ActiveRecord::Migration[5.1]
  def change
    create_table :images do |t|
      t.string :description
      t.string :image
      t.integer :likes_count
      t.integer :comments_count
      t.belongs_to :photo_album, index: true

      t.timestamps
    end
  end
end
