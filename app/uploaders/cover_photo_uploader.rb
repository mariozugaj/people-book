# frozen_string_literal: true

class CoverPhotoUploader < CarrierWave::Uploader::Base
  Rails.env.production? ? (storage :aws) : (storage :file)

  include UploaderHelper

  version :normal do
    process resize_to_fill: [840, 313]
  end

  def default_url(*_args)
    'https://s3.eu-central-1.amazonaws.com/chanjman-peoplebook/missing/cover/missing.jpg'
  end
end
