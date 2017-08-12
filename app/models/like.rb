# == Schema Information
#
# Table name: likes
#
#  id            :integer          not null, primary key
#  likeable_type :string
#  likeable_id   :integer
#  user_id       :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Like < ApplicationRecord
  # Associations
  belongs_to :likeable, polymorphic: true, counter_cache: true
  belongs_to :user

  # Validations
  validates_presence_of :user, :likeable_id, :likeable_type
  validates_uniqueness_of :user_id,
                          scope: %i[likeable_id likeable_type],
                          message: 'can\'t like more than once'

  # Slug
  include Slug
end
