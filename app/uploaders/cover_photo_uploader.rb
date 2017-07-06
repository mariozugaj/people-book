class CoverPhotoUploader < CarrierWave::Uploader::Base

  include UploaderHelper

  version :normal do
    process resize_to_fill: [1200, 300]
  end

  def default_url(*args)
    'https://s3.eu-central-1.amazonaws.com/chanjman-peoplebook/missing/cover/missing.jpg'
  end
end
