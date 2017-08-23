require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'support/fixture_file_helpers'
require 'support/omniauth_helpers'
require 'support/integration_test_helpers'
require 'support/system_test_helpers'
require 'support/carrierwave_config'
require 'minitest/autorun'


class ActiveSupport::TestCase
  include OmniauthHelper
  include CarrierwaveConfig
  fixtures :all

  OmniAuth.config.test_mode = true
  Searchkick.disable_callbacks
  Capybara.default_max_wait_time = 10
end

class ActionDispatch::IntegrationTest
  include IntegrationTestHelpers
  include CarrierwaveConfig
  Searchkick.disable_callbacks
  Capybara.default_max_wait_time = 10
end

class ActionDispatch::SystemTestCase
  include SystemTestHelpers
  include CarrierwaveConfig
  Searchkick.disable_callbacks
  Capybara.default_max_wait_time = 10
end
