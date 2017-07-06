class StatusImageUploader < CarrierWave::Uploader::Base
  include UploaderHelper

  version :normal do
    process resize_to_fill: [800, 400]
  end
end
