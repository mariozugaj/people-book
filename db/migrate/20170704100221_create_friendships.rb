class CreateFriendships < ActiveRecord::Migration[5.1]
  def change
    create_table :friendships do |t|
      t.references :user, references: :users, null: false
      t.references :friend, references: :users, null: false
      t.boolean :accepted, default: false

      t.timestamps
    end
    add_index :friendships, %i[user_id friend_id accepted]
  end
end
