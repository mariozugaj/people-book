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
    @profile.birthday = '1985-07-29'
    Time.stub :current, Time.new(2017, 8, 17) do
      assert_equal 32, @profile.age
    end
  end
end
