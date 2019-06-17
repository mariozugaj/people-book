# frozen_string_literal: true

class CreateComments < ActiveRecord::Migration[5.1]
  def change
    create_table :comments do |t|
      t.belongs_to :commentable, polymorphic: true
      t.belongs_to :author
      t.text :text
      t.integer :likes_count

      t.timestamps
    end
  end
end
