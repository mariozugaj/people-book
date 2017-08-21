require 'test_helper'

class SlugTest < ActiveSupport::TestCase
  def setup
    @user = users(:maymie)
  end

  test 'gets created on create commit' do
    @user.save
    refute @user.slug.blank?
    assert_equal @user.to_param, @user.slug
  end
end
