module SystemTestHelpers
  def log_in_as(user)
    visit welcome_url
    within('div.right div.item') do
      click_link 'Log in'
    end
    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: 'password123'
    click_button 'Log in'
  end

  def log_out
    find('div#user_links').hover
    sleep 2
    click_link 'Log out'
  end

  def in_browser(name)
    old_session = Capybara.session_name

    Capybara.session_name = name
    yield

    Capybara.session_name = old_session
  end
end
