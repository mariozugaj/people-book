require 'test_helper'

class RegistrationFlowTest < ActionDispatch::IntegrationTest
  include ActiveJob::TestHelper

  test 'welcome email delivery' do
    assert_enqueued_jobs 1 do
      get welcome_url
      post '/users', params: { user: { name: 'Destin Rotsford',
                                       email: 'destin@rotsford.com',
                                       password: 'password123' } }
    end
  end
end
