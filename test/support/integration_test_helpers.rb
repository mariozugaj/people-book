module IntegrationTestHelpers
  def log_in_as(user, password: 'password123')
    delete destroy_user_session_path
    post user_session_path, params: { user: { email: user.email,
                                              password: password } }
  end
end
