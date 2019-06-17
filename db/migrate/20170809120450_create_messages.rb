# frozen_string_literal: true

class CreateMessages < ActiveRecord::Migration[5.1]
  def change
    create_table :messages do |t|
      t.text :body
      t.belongs_to :conversation, foreign_key: true
      t.belongs_to :user, foreign_key: true
      t.boolean :read, default: false

      t.timestamps
    end
  end
end
