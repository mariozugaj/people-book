# frozen_string_literal: true

require 'test_helper'

class RegistrationFlowTest < ActionDispatch::IntegrationTest
  include ActiveJob::TestHelper

  test 'welcome email delivery' do
    assert_enqueued_jobs 1 do
      get welcome_url
      post user_registration_path, params: { user: { name: 'Destin Rotsford',
                                                     email: 'destin@rotsford.com',
                                                     password: 'password123' } }
    end
  end
end
