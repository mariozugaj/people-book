# frozen_string_literal: true

require 'test_helper'

class ProfileTest < ActiveSupport::TestCase
  def setup
    @profile = Profile.new(
      user: users(:lydia)
    )
  end

  # Validation tests

  test 'should be valid' do
    assert @profile.valid?
  end

  test 'returns education' do
    @profile.education = 'Master of Criminology'
    assert_equal 'Master of Criminology', @profile.education
  end

  test 'returns age value' do
    @profile.birthday = Date.new(1985, 7, 29)
    Date.stub :today, Date.new(2017, 8, 17) do
      assert_equal 32, @profile.age
    end
  end
end
