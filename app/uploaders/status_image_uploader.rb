class StatusImageUploader < CarrierWave::Uploader::Base
  include UploaderHelper

  Rails.env.production? ? (storage :aws) : (storage :file)

  version :normal do
    process resize_to_limit: [840, 420]
  end
end
