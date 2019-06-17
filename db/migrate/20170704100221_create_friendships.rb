# frozen_string_literal: true

class CreateFriendships < ActiveRecord::Migration[5.1]
  def change
    create_table :friendships do |t|
      t.references :user, references: :users, null: false
      t.references :friend, references: :users, null: false
      t.integer :status, index: true, null: false

      t.timestamps
    end
  end
end
