class CreateNotifications < ActiveRecord::Migration[5.1]
  def change
    create_table :notifications do |t|
      t.belongs_to :recipient, class_name: 'User', index: true
      t.belongs_to :actor, class_name: 'User', index: true
      t.belongs_to :notifiable, polymorphic: true, index: true
      t.integer :read_at

      t.timestamps
    end
  end
end
