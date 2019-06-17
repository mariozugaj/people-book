# frozen_string_literal: true

class PhotoAlbumImageUploader < CarrierWave::Uploader::Base
  include UploaderHelper

  Rails.env.production? ? (storage :aws) : (storage :file)

  version :normal do
    process resize_to_limit: [1200, 1200]
  end

  version :mini, from_version: :normal do
    process resize_to_fill: [250, 190]
  end

  version :thumb, from_version: :mini do
    process resize_to_fill: [50, 50]
  end
end
