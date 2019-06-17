# frozen_string_literal: true

require 'test_helper'

class PhotoAlbumTest < ActiveSupport::TestCase
  def setup
    @photo_album = photo_albums(:first)
  end

  test 'should be valid' do
    assert @photo_album.valid?
  end

  test 'return its first image url' do
    assert_equal '/uploads/image/309456473/image/mini_haha.jpg', @photo_album.first_image
  end
end
