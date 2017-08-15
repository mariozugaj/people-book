# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  name                   :string           not null
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  provider               :string
#  uid                    :string
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  slug                   :string
#

class User < ApplicationRecord
  # Devise
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  # Associations
  has_one :profile, dependent: :destroy, inverse_of: :user
  has_many :photo_albums, foreign_key: 'author_id', dependent: :destroy
  has_many :status_updates, foreign_key: 'author_id', dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :comments, foreign_key: 'author_id', dependent: :destroy
  has_many :images, through: :photo_albums
  has_many :notifications, foreign_key: :recipient_id
  has_many :sent_notifications,
           class_name: 'Notification',
           foreign_key: :actor_id,
           dependent: :destroy
  has_many :conversations, ->(user) { Conversation.with_user(user) },
           dependent: :destroy
  has_many :messages

  # Validations
  validates_presence_of :name, :email, :password

  # Delegations
  delegate :avatar, to: :profile

  # Search
  searchkick text_middle: [:name]
  scope :search_import, -> { includes(:profile) }

  # Slug
  include Slug
  include Friendable

  def online?
    !Redis.new.get("user_#{id}_online").nil?
  end

  def search_info
    {
      title: name,
      image: avatar.url(:thumb),
      url: Rails.application.routes.url_helpers.user_path(self),
      description: profile.hometown || ''
    }
  end

  def unread_conversations_count
    conversations
      .select { |c| c.messages.not_sent_by(self).unread.exists? }
      .count
  end

  def self.from_omniauth(auth)
    where(email: auth.info.email).first_or_create do |user|
      break unless auth.info.email
      user.email = auth.info.email
      user.password = Devise.friendly_token(40)
      user.name = auth.info.name
      Profile.create! user: user,
                      remote_avatar_url: auth.info.image
      avatars = PhotoAlbum.create(author: user, name: 'Avatars')
      avatars.images.create(remote_image_url: auth.info.image)
      PhotoAlbum.create(author: user, name: 'Cover photos')
    end
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session['devise.facebook_data'] && session['devise.facebook_data']['extra']['raw_info']
        user.email = data['email'] if user.email.blank?
      end
    end
  end
end
