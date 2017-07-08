class StatusImageUploader < CarrierWave::Uploader::Base
  include UploaderHelper

  Rails.env.production? ? (storage :aws) : (storage :file)

  version :normal do
    process resize_to_limit: [840, 420]
  end

  def default_url(*args)
    'https://s3.eu-central-1.amazonaws.com/chanjman-peoplebook/missing/status/missing.jpg'
  end
end
