require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'support/fixture_file_helpers'
require 'support/omniauth_helpers'
require 'support/integration_test_helpers'
require 'support/system_test_helpers'
require 'support/carrierwave_config'
require 'minitest/autorun'

include CarrierwaveConfig

class ActiveSupport::TestCase
  include OmniauthHelper
  fixtures :all

  OmniAuth.config.test_mode = true
end

class ActionDispatch::IntegrationTest
  include IntegrationTestHelpers
end

class ActionDispatch::SystemTestCase
  include SystemTestHelpers
end

Searchkick.disable_callbacks
Capybara.default_max_wait_time = 10