class AvatarUploader < CarrierWave::Uploader::Base

  include UploaderHelper

  Rails.env.production? ? (storage :aws) : (storage :file)

  version :normal do
    process resize_to_fill: [260, 240]
  end

  version :mini, from_version: :normal do
    process resize_to_fill: [80, 75]
  end

  version :thumb, from_version: :mini do
    process resize_to_fill: [54, 50]
  end

  def default_url(*args)
    'https://s3.eu-central-1.amazonaws.com/chanjman-peoplebook/missing/avatar/missing.png'
  end
end
