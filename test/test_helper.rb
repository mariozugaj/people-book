# frozen_string_literal: true

require File.expand_path('../config/environment', __dir__)
require 'rails/test_help'
require 'support/fixture_file_helpers'
require 'support/omniauth_helpers'
require 'support/integration_test_helpers'
require 'support/system_test_helpers'
require 'minitest/autorun'

class ActiveSupport::TestCase
  include OmniauthHelper
  include IntegrationTestHelpers

  fixtures :all

  OmniAuth.config.test_mode = true
  Searchkick.disable_callbacks
  Capybara.default_max_wait_time = 10
end

class ActionDispatch::SystemTestCase
  include SystemTestHelpers

  fixtures :all
  OmniAuth.config.test_mode = true
  Searchkick.disable_callbacks
  Capybara.default_max_wait_time = 10
end
