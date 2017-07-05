class Like < ApplicationRecord
  belongs_to :likeable, polymorphic: true, counter_cache: true
  belongs_to :user

  validates_presence_of :user, :likeable_id, :likeable_type
end
