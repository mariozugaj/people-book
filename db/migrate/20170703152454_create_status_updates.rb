# frozen_string_literal: true

class CreateStatusUpdates < ActiveRecord::Migration[5.1]
  def change
    create_table :status_updates do |t|
      t.belongs_to :author, index: true
      t.text :text
      t.integer :likes_count
      t.integer :comments_count
      t.string :image

      t.timestamps
    end
  end
end
