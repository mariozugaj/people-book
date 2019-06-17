# frozen_string_literal: true

module OmniauthHelper
  def mock_auth_hash_new
    OmniAuth.config.mock_auth[:default] = OmniAuth::AuthHash.new(
      provider: 'facebook',
      uid: '123545',
      info: {
        name: 'Destin Botsford',
        email: 'destin@botsford.com'
      },
      credentials: {
        token: 'mock_token',
        secret: 'mock_secret'
      }
    )
  end

  def mock_auth_hash_existing
    OmniAuth.config.mock_auth[:default] = OmniAuth::AuthHash.new(
      provider: 'facebook',
      uid: '1323222024398387',
      info: {
        name: 'Maymie Blick',
        email: 'maymie@blick.com'
      },
      credentials: {
        token: 'mock_token',
        secret: 'mock_secret'
      }
    )
  end

  def mock_auth_hash_new_no_email
    OmniAuth.config.mock_auth[:default] = OmniAuth::AuthHash.new(
      provider: 'facebook',
      uid: '123545',
      info: {
        name: 'Destin Botsford'
      },
      credentials: {
        token: 'mock_token',
        secret: 'mock_secret'
      }
    )
  end
end
