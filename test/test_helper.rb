require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'support/fixture_file_helpers'
require 'support/omniauth_helpers.rb'
require 'minitest/autorun'


class ActiveSupport::TestCase
  fixtures :all
  include OmniauthHelper
  OmniAuth.config.test_mode = true
  Searchkick.disable_callbacks
end

require 'fileutils'

carrierwave_template = Rails.root.join('test', 'fixtures', 'files', 'uploads')
carrierwave_root = Rails.root.join('test', 'support', 'carrierwave')

CarrierWave.configure do |config|
  config.root = carrierwave_root
  config.enable_processing = false
  config.storage = :file
  config.cache_dir = Rails.root.join('test', 'support', 'carrierwave', 'carrierwave_cache')
end

FileUtils.cp_r carrierwave_template, carrierwave_root

at_exit do
  Dir.glob(carrierwave_root.join('*')).each do |dir|
    FileUtils.remove_entry(dir)
  end
end

class ActionDispatch::IntegrationTest
  def log_in_as(user, password: 'password123')
    delete destroy_user_session_path
    post user_session_path, params: { user: { email: user.email,
                                              password: password } }
  end
end

class ActionDispatch::SystemTestCase
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
end
