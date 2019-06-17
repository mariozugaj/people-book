# frozen_string_literal: true

# == Schema Information
#
# Table name: notifications
#
#  id              :integer          not null, primary key
#  recipient_id    :integer
#  actor_id        :integer
#  notifiable_type :string
#  notifiable_id   :integer
#  read            :boolean          default(FALSE)
#  action          :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  slug            :string           not null
#

class Notification < ApplicationRecord
  include Slug

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
end
