# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  name                   :string           not null
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
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
#

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  has_one :profile, dependent: :destroy, inverse_of: :user
  has_one :avatar, through: :profile
  has_one :cover_photo, through: :profile
  has_many :photo_albums, dependent: :destroy
  has_many :status_updates, foreign_key: 'author_id', dependent: :destroy

  has_many :received_friend_requests, class_name: 'Friendship',
                                      foreign_key: 'friend_id',
                                      dependent: :destroy

  has_many :sent_friend_requests, class_name: 'Friendship',
                                  foreign_key: 'user_id',
                                  dependent: :destroy

  validates_presence_of :name, :email, :password

  after_create :create_profile

  def friendships
    Friendship.where('accepted = ? AND (user_id = ? OR friend_id = ?)', true, id, id)
  end

  def friend_ids
    friendships.map { |f| f.user_id == id ? f.friend_id : f.user_id }
  end

  def friends
    User.where('id in (?)', friend_ids)
  end

  def friend_with?(user)
    friends.include? user
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email if auth.info.email
      user.password = Devise.friendly_token(40)
      user.name = auth.info.name
      Profile.create! user: user, remote_avatar_url: auth[:info][:image]
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
