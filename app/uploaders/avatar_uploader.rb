class AvatarUploader < CarrierWave::Uploader::Base

  include UploaderHelper

  version :thumb do
    process resize_to_fill: [50, 50]
  end

  version :normal do
    process resize_to_fill: [300, 300]
  end

  def default_url(*args)
    'https://s3.eu-central-1.amazonaws.com/chanjman-peoplebook/missing/avatar/missing.png'
  end
end
