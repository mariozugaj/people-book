class CreateImageAttachments < ActiveRecord::Migration[5.1]
  def change
      create_table :image_attachments do |t|
        t.belongs_to :imageable, polymorphic: true
        t.attachment :data
        t.boolean    :default, default: false

        t.timestamps
      end

      add_index :image_attachments, [:imageable_id, :imageable_type, :default],
        unique: true,
        where:  '"default" = TRUE',
        name:   :unique_on_imageable_default
    end
end
