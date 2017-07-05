require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module PeopleBook
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Add node modules to pipeline
    config.assets.paths << Rails.root.join('node_modules')

    #paperclip S3
    config.paperclip_defaults = {
      storage: :s3,
      s3_region: Figaro.env.AWS_S3_REGION,
      s3_credentials: {
        s3_host_name: Figaro.env.AWS_S3_HOST_NAME,
        bucket: Figaro.env.AWS_S3_BUCKET,
        access_key_id: Figaro.env.AWS_ACCESS_KEY_ID,
        secret_access_key: Figaro.env.AWS_SECRET_ACCESS_KEY
      }
    }
  end
end
