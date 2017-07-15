class StatusImageUploader < CarrierWave::Uploader::Base
  include UploaderHelper

  Rails.env.production? ? (storage :aws) : (storage :file)

  version :normal do
    process resize_to_limit: [840, 420]
  end

  version :thumb, from_version: :normal do
    process resize_to_fill: [54, 50]
  end
end
