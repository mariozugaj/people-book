module FixtureFileHelpers
  def encrypted_password(password = 'password123')
    User.new.send(:password_digest, password)
  end
end

ActiveRecord::FixtureSet.context_class.send :include, FixtureFileHelpers