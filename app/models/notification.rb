# == Schema Information
#
# Table name: notifications
#
#  id              :integer          not null, primary key
#  recipient_id    :integer
#  actor_id        :integer
#  notifiable_type :string
#  notifiable_id   :integer
#  read_at         :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Notification < ApplicationRecord
  # Associations
  belongs_to :recipient, class_name: 'User'
  belongs_to :actor, class_name: 'User'
  belongs_to :notifiable, polymorphic: true

  # Validations
  validates_presence_of :recipient, :actor, :notifiable

  # Scopes
  scope :recent, -> { order(created_at: :desc).limit(7) }
  scope :unread, -> { where(read_at: nil) }
  scope :read, -> { where('read_at IS NOT NULL') }
end
