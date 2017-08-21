require 'test_helper'

class PhotoAlbumTest < ActiveSupport::TestCase
  def setup
    @photo_album = photo_albums(:first)
  end

  test 'should be valid' do
    assert @photo_album.valid?
  end

  test 'return its first image' do
    assert_equal 'lights.jpg', @photo_album.first_image.file.filename
  end
end
