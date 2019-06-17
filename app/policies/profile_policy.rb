# frozen_string_literal: true

class ProfilePolicy
  attr_reader :user, :profile

  def initialize(user, profile)
    @user = user
    @profile = profile
  end

  def edit?
    owner?
  end

  def update?
    owner?
  end

  def set_avatar?
    owner?
  end

  def set_cover?
    owner?
  end

  private

  def owner?
    user == profile.user
  end
end
