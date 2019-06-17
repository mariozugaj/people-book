# frozen_string_literal: true

module IntegrationTestHelpers
  def log_in_as(user, password: 'password123')
    delete destroy_user_session_path
    post user_session_path, params: { user: { email: user.email,
                                              password: password } }
  end

  def assert_differences(expression_array, message = nil, &block)
    b = block.send(:binding)
    before = expression_array.map { |expr| eval(expr[0], b) }

    yield

    expression_array.each_with_index do |pair, i|
      e = pair[0]
      difference = pair[1]
      error = "#{e.inspect} didn't change by #{difference}"
      error = "#{message}\n#{error}" if message
      assert_equal(before[i] + difference, eval(e, b), error)
    end
  end
end
