require 'application_system_test_case'

class LoginTest < ApplicationSystemTestCase
  setup do
    @user = users :maymie
  end

  test 'successful login' do
    visit welcome_url
    within('div.right div.item') do
      click_link 'Log in'
    end
    fill_in 'user[email]', with: @user.email
    fill_in 'user[password]', with: 'password123'
    click_button 'Log in', wait: true

    assert_current_path home_path, only_path: true
    assert_text 'Signed in successfully.'
    assert_selector :link, text: 'Maymie Blick'
  end

  test 'unsuccessful login' do
    visit welcome_url
    within('div.right div.item') do
      click_link 'Log in'
    end

    fill_in 'user[email]', with: ''
    fill_in 'user[password]', with: ''
    click_button 'Log in'
    assert_text 'Please enter your password'
    assert_text 'Please enter your email'

    fill_in 'user[email]', with: 'destin'
    click_button 'Log in'
    assert_text 'That email doesn\'t look right'

    fill_in 'user[email]', with: 'example@example.com'
    click_button 'Log in'
    assert_text 'Sorry, we can\'t find a user with that email'

    assert_no_current_path home_path, only_path: true
  end
end
