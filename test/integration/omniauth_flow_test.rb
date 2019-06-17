# frozen_string_literal: true

require 'test_helper'

class OmniauthFlowTest < ActionDispatch::IntegrationTest
  include ActiveJob::TestHelper

  setup do
    Rails.application.env_config['devise.mapping'] = Devise.mappings[:user]
  end

  teardown do
    OmniAuth.config.mock_auth[:default] = nil
  end

  test 'successful facebook omniauth registration' do
    signup_through_facebook

    assert_redirected_to home_path
    follow_redirect!
    assert_equal 'Successfully authenticated from Facebook account.', flash[:notice]
    assert_select 'a', 'PeopleBook'
    assert_select 'a', 'Destin Botsford'
    assert_enqueued_jobs 1
  end

  test 'successful facebook omniauth login' do
    login_through_facebook

    assert_redirected_to home_path
    follow_redirect!
    assert_equal 'Successfully authenticated from Facebook account.', flash[:notice]
    assert_select 'a', 'PeopleBook'
    assert_select 'a', 'Maymie Blick'
  end

  test 'omniauth facebook signup created profile' do
    assert_difference 'Profile.count', 1 do
      signup_through_facebook
    end
  end

  test 'omniauth facebook signup created photo albums' do
    assert_difference 'PhotoAlbum.count', 2 do
      signup_through_facebook
    end
  end

  test 'omniauth facebook login doesn\'t create new profile/photo albums' do
    assert_no_difference ['PhotoAlbum.count', 'Profile.count'] do
      login_through_facebook
    end
  end

  test 'redirects to signup page on failure' do
    get welcome_url
    OmniAuth.config.mock_auth[:default] = :invalid_credentials
    post user_facebook_omniauth_authorize_path
    follow_redirect!
    assert_redirected_to new_user_registration_path
    assert_equal "Sorry, we couldn't log you in through Facebook.", flash[:notice]
  end

  test 'redirects to signup page if auth email blank' do
    get welcome_url
    mock_auth_hash_new_no_email
    post user_facebook_omniauth_authorize_path
    follow_redirect!
    assert_redirected_to new_user_registration_path
    assert_equal "Sorry, we couldn't log you in through Facebook.", flash[:notice]
  end

  private

  def signup_through_facebook
    get welcome_url
    mock_auth_hash_new
    post user_facebook_omniauth_authorize_path
    follow_redirect!
  end

  def login_through_facebook
    get welcome_url
    mock_auth_hash_existing
    post user_facebook_omniauth_authorize_path
    follow_redirect!
  end
end
