# frozen_string_literal: true

require 'application_system_test_case'

class RegistrationTest < ApplicationSystemTestCase
  include ActiveJob::TestHelper

  test 'visiting welcome page' do
    visit welcome_url

    assert_selector 'h1', text: 'PeopleBook'
    assert_selector :link, text: 'Log in'
    assert_selector 'h2', text: 'Sign up'
  end

  test 'successful manual registration' do
    visit welcome_url

    fill_in 'user[name]', with: 'Destin Botsford'
    fill_in 'user[email]', with: 'destin@botsford.com'
    fill_in 'user[password]', with: 'password123'
    click_button 'Sign up for PeopleBook', wait: true

    assert_current_path home_path, only_path: true
    assert_selector :link, text: 'Destin Botsford'
    assert_text 'Welcome! You have signed up successfully.'
  end

  test 'unsuccessful manual registration' do
    visit welcome_url

    fill_in 'user[name]', with: ''
    fill_in 'user[email]', with: ''
    fill_in 'user[password]', with: ''
    click_button 'Sign up for PeopleBook'

    assert_text 'Please enter your full name'
    assert_text 'Please enter your email'
    assert_text 'Please enter your password'

    fill_in 'user[email]', with: 'destin'
    click_button 'Sign up for PeopleBook'
    assert_text 'That email doesn\'t look right'

    fill_in 'user[email]', with: users(:maymie).email, wait: true
    click_button 'Sign up for PeopleBook'
    assert_text 'Sorry, that email has been taken'

    fill_in 'user[password]', with: 'pass'
    click_button 'Sign up for PeopleBook'
    assert_text 'Please enter a 6 characters minimum password'
    assert_no_current_path home_path, only_path: true
  end
end
