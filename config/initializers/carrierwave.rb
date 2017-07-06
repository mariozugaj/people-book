CarrierWave.configure do |config|
  config.storage    = :aws
  config.aws_bucket = Figaro.env.AWS_S3_BUCKET
  config.aws_acl    = 'public-read'

  # The maximum period for authenticated_urls is only 7 days.
  config.aws_authenticated_url_expiration = 60 * 60 * 24 * 7

  # Set custom options such as cache control to leverage browser caching
  config.aws_attributes = {
    expires: 1.week.from_now.httpdate,
    cache_control: 'max-age=604800'
  }

  config.aws_credentials = {
    access_key_id:     Figaro.env.AWS_ACCESS_KEY_ID,
    secret_access_key: Figaro.env.AWS_SECRET_ACCESS_KEY,
    region:            Figaro.env.AWS_S3_REGION
  }
end
