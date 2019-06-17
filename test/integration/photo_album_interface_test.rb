# frozen_string_literal: true

require 'test_helper'

class PhotoAlbumInterfaceTest < ActionDispatch::IntegrationTest
  include ActiveJob::TestHelper

  setup do
    @user = users :maymie
    @photo_album = photo_albums :first
    @image = fixture_file_upload('test/fixtures/files/haha.jpg', 'image/jpg')
    @images = [fixture_file_upload('test/fixtures/files/haha.jpg', 'image/jpg'),
               fixture_file_upload('test/fixtures/files/hahafa.jpg', 'image/jpg')]
    @cloud_image = 'http://via.placeholder.com/350x150'
  end

  test 'creates new album without images' do
    log_in_as @user
    get user_photo_albums_path(@user)
    assert_select 'a', text: 'New Photo Album'
    get new_user_photo_album_path(@user)
    assert_select "form[action = '#{user_photo_albums_path(@user)}']" do
      assert_select 'input', count: 5
    end
    assert_difference 'PhotoAlbum.count', 1 do
      post user_photo_albums_path(@user),
           params: { photo_album: { name: 'Highlights',
                                    description: 'Highlights' } }
    end
    assert_redirected_to user_photo_album_path(@user, PhotoAlbum.last)
    follow_redirect!
    assert_match 'Highlights', response.body
    assert_select 'a', text: 'EDIT or ADD new images'
    assert_select 'a', text: 'Back to photo albums'
  end

  test 'creates photo_album with single uploaded image' do
    visit_new_photo_album

    assert_difference ['PhotoAlbum.count', 'Image.count'], 1 do
      post user_photo_albums_path(@user),
           params: { photo_album: { name: 'Highlights',
                                    description: 'Highlights' },
                     'images[image][]' => @image }
    end
  end

  test 'creates photo_album with multiple uploaded images' do
    visit_new_photo_album

    assert_differences([['PhotoAlbum.count', 1], ['Image.count', 2]]) do
      post user_photo_albums_path(@user),
           params: { photo_album: { name: 'Highlights',
                                    description: 'Highlights' },
                     'images[image]' => @images }
    end
  end

  test 'creates photo_album with remote image' do
    visit_new_photo_album

    assert_difference ['PhotoAlbum.count', 'Image.count'] do
      post user_photo_albums_path(@user),
           params: { photo_album: { name: 'Highlights',
                                    description: 'Highlights' },
                     cloud_image: { remote_image_url: @cloud_image } }
    end
  end

  test 'creates photo_album with both remote image and uploaded images' do
    visit_new_photo_album

    assert_differences([['PhotoAlbum.count', 1], ['Image.count', 3]]) do
      post user_photo_albums_path(@user),
           params: { photo_album: { name: 'Highlights',
                                    description: 'Highlights' },
                     'images[image]' => @images,
                     cloud_image: { remote_image_url: @cloud_image } }
    end
  end

  test 'adds new uploaded images to existing photo album, ceteris paribus' do
    log_in_as @user
    get edit_user_photo_album_path(@user, @photo_album)

    assert_difference 'Image.count', 2 do
      patch user_photo_album_path(@user, @photo_album),
            params: { photo_album: { name: 'Highlights',
                                     description: 'Highlights' },
                      'images[image]' => @images }
    end
    assert_redirected_to user_photo_album_path(@user, @photo_album)
    follow_redirect!
    assert_select "div[class = 'ui attached segment']" do
      assert_select 'img', count: 3
    end
  end

  test 'adds new cloud image to existing photo album, ceteris paribus' do
    log_in_as @user
    get edit_user_photo_album_path(@user, @photo_album)

    assert_difference 'Image.count', 1 do
      patch user_photo_album_path(@user, @photo_album),
            params: { photo_album: { name: 'Highlights',
                                     description: 'Highlights' },
                      cloud_image: { remote_image_url: @cloud_image } }
    end
    assert_redirected_to user_photo_album_path(@user, @photo_album)
    follow_redirect!
    assert_select "div[class = 'ui attached segment']" do
      assert_select 'img', count: 2
    end
  end

  test 'updated name/description of existing photo album, ceteris paribus' do
    log_in_as @user
    get edit_user_photo_album_path(@user, @photo_album)

    patch user_photo_album_path(@user, @photo_album),
          params: { photo_album: { name: 'New highlights',
                                   description: 'New highlights' } }
    assert_redirected_to user_photo_album_path(@user, @photo_album)
    follow_redirect!
    assert_match 'New highlights', response.body
  end

  test 'deletes images from existing photo album' do
    log_in_as @user
    get edit_user_photo_album_path(@user, @photo_album)

    assert_difference 'Image.count', -1 do
      delete image_path(@photo_album.images.first),
             params: { photo_album_id: @photo_album.slug }
    end
    assert_redirected_to edit_user_photo_album_path(@user, @photo_album)
    follow_redirect!
    assert_equal 'Image was successfuly destroyed', flash[:success]
    get user_photo_album_path(@user, @photo_album)
    assert_select "div[class = 'ui attached segment']" do
      assert_select 'img', count: 0
    end
    assert_match 'No images', response.body
  end

  test 'deletes existing photo album' do
    log_in_as @user
    get edit_user_photo_album_path(@user, @photo_album)

    assert_difference 'PhotoAlbum.count', -1 do
      delete user_photo_album_path(@user, @photo_album)
    end
    assert_redirected_to user_photo_albums_path(@user)
    follow_redirect!
    assert_equal 'Photo album was successfully destroyed.', flash[:success]
    assert_select "div[class = 'ui three stackable cards']" do
      assert_select "a[class = 'ui card']", count: 2 do
        assert_select 'div.header', text: @photo_album.name, count: 0
      end
    end
  end

  test 'photo album/image authorizations' do
    log_in_as users(:ronny)

    get edit_user_photo_album_path(@user, @photo_album)
    assert_redirected_to home_path

    delete user_photo_album_path(@user, @photo_album)
    assert_redirected_to home_path

    patch user_photo_album_path(@user, @photo_album),
          params: { photo_album: { name: 'My highlights',
                                   description: 'My highlights' },
                    cloud_image: { remote_image_url: @cloud_image } }
    assert_redirected_to home_path

    delete image_path(@photo_album.images.first),
           params: { photo_album_id: @photo_album.slug }
    assert_redirected_to home_path

    patch image_path(@photo_album.images.first),
          params: { description: 'My new image' }
    assert_redirected_to home_path
  end

  test 'updating existing image' do
    log_in_as @user
    get edit_image_path(@photo_album.images.first)

    patch image_path(@photo_album.images.first),
          params: { description: 'Bright blue water' }

    assert_redirected_to image_path(@photo_album.images.first)
    follow_redirect!
    assert_match 'Bright blue water', response.body
  end

  test 'uploading images sends notification' do
    log_in_as @user

    assert_enqueued_with(job: NotificationRelayJob, queue: 'default') do
      patch user_photo_album_path(@user, @photo_album),
            params: { photo_album: { name: 'Highlights',
                                     description: 'Highlights' },
                      cloud_image: { remote_image_url: @cloud_image } }
    end
  end

  def visit_new_photo_album
    log_in_as @user
    get user_photo_albums_path(@user)
    get new_user_photo_album_path(@user)
  end
end
