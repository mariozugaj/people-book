class AvatarUploader < CarrierWave::Uploader::Base

  include UploaderHelper

  Rails.env.production? ? (storage :aws) : (storage :file)

  version :thumb do
    process resize_to_fill: [54, 50]
  end

  version :normal do
    process resize_to_fill: [260, 240]
  end

  def default_url(*args)
    'https://s3.eu-central-1.amazonaws.com/chanjman-peoplebook/missing/avatar/missing.png'
  end
end
