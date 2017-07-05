class CreateLikes < ActiveRecord::Migration[5.1]
  def change
    create_table :likes do |t|
      t.belongs_to :likeable, polymorphic: true
      t.belongs_to :user

      t.timestamps
    end
    add_index :likes, %i[likeable_id likeable_type user_id],
              name: :index_on_likeable
  end
end
