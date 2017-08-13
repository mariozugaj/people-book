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
#  action          :string
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
  scope :ordered, -> { order(created_at: :desc) }
  scope :recent, -> { ordered.limit(10) }
  scope :unread, -> { where(read: false) }
  scope :read, -> { where(read: true) }

  # Slug
  include Slug
end
