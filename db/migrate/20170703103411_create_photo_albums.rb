# frozen_string_literal: true

class CreatePhotoAlbums < ActiveRecord::Migration[5.1]
  def change
    create_table :photo_albums do |t|
      t.references :author, class_name: 'User', index: true
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
