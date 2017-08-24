class CreateProfiles < ActiveRecord::Migration[5.1]
  def change
    create_table :profiles do |t|
      t.references :user, foreign_key: true, null: false, unique: true
      t.date :birthday
      t.string :education
      t.string :hometown
      t.string :profession
      t.string :company
      t.string :relationship_status
      t.string :about
      t.string :phone_number
      t.string :avatar
      t.string :cover_photo

      t.timestamps
    end
  end
end
