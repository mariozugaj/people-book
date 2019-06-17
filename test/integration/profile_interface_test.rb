# frozen_string_literal: true

require 'test_helper'

class ProfileInterfaceTest < ActionDispatch::IntegrationTest
  include ActiveJob::TestHelper

  setup do
    @user = users :maymie
    @user2 = users :antonina
    @image = fixture_file_upload('test/fixtures/files/hahafa.jpg')
    @avatars_album = photo_albums :second
    @covers_album = photo_albums :third
  end

  test 'aside profile info filled in layout' do
    log_in_as @user
    get user_path(@user)
    assert_select 'h2', text: @user.name
    assert_select 'div.description', text: @user.profile.about
    assert_select 'p', text: "#{@user.profile.age} years old"
    assert_select 'p', text: @user.profile.education
    assert_select 'p', text: @user.profile.hometown
    assert_select 'p', text: "#{@user.profile.profession} @ #{@user.profile.company}"
    assert_select 'p', text: @user.profile.relationship_status
    assert_select 'p', text: @user.email
    assert_select 'p', text: @user.profile.phone_number
  end

  test 'aside profile info blank layout' do
    log_in_as @user2
    get user_path(@user2)
    assert_select 'h2', text: @user2.name
    assert_select 'div.description', text: 'About'
    assert_select 'p', text: 'Age'
    assert_select 'p', text: 'Education'
    assert_select 'p', text: 'Hometown'
    assert_select 'p', text: 'Profession Company'
    assert_select 'p', text: 'Relationship status'
    assert_select 'p', text: @user2.email
    assert_select 'p', text: 'Phone number'
  end

  test 'invalid submission returns errors' do
    log_in_as @user
    get edit_user_profile_path(@user)

    patch user_profile_path(@user),
          params: { profile:
            {
              birthday: 12.years.ago,
              education: Faker::Lorem.sentence(20),
              hometown: Faker::Lorem.sentence(20),
              profession: Faker::Lorem.sentence(20),
              company: Faker::Lorem.sentence(20),
              about: Faker::Lorem.sentence(40),
              phone_number: Faker::Lorem.sentence(20)
            }, profile_id: @user.profile.slug }
    assert_equal 'There was a problem updating your profile. Try again?',
                 flash[:alert]
    assert_select 'div#error_explanation ul' do |elements|
      elements.each do |element|
        assert_select element, 'li', 7
      end
    end
  end

  test 'valid submission' do
    log_in_as @user
    get edit_user_profile_path(@user)

    patch user_profile_path(@user),
          params: { profile:
            {
              birthday: 18.years.ago,
              education: Faker::Educator.course,
              hometown: Faker::Address.city,
              profession: Faker::Job.title,
              company: Faker::Company.name,
              about: Faker::Lorem.sentence(10),
              phone_number: Faker::PhoneNumber.phone_number
            }, profile_id: @user.profile.slug }
    assert_equal 'You\'ve successfuly updated your profile', flash[:success]
  end

  test 'valid submission sends notification' do
    ActiveJob::Base.queue_adapter.perform_enqueued_jobs = true

    log_in_as @user
    get edit_user_profile_path(@user)
    assert_performed_jobs 1 do
      patch user_profile_path(@user),
            params: { profile: { birthday: 33.years.ago },
                      profile_id: @user.profile.slug }
    end
  end

  test 'update avatar image' do
    ActiveJob::Base.queue_adapter.perform_enqueued_jobs = true

    log_in_as @user
    get edit_user_photo_album_path(@user, @avatars_album)

    patch user_photo_album_path(@user, @avatars_album),
          params: { photo_album: { name: 'Avatars' },
                    'images[image][]' => @image }
    get image_path(@avatars_album.images.last)
    post user_set_avatar_path(@user),
         params: { image_id: @avatars_album.images.last.slug }
    assert_equal 'You\'ve successfuly updated your avatar', flash[:success]
  end

  test 'update cover image' do
    ActiveJob::Base.queue_adapter.perform_enqueued_jobs = true

    log_in_as @user
    get edit_user_photo_album_path(@user, @covers_album)

    patch user_photo_album_path(@user, @covers_album),
          params: { photo_album: { name: 'Cover photos' },
                    'images[image][]' => @image }
    get image_path(@covers_album.images.last)
    post user_set_cover_path(@user),
         params: { image_id: @covers_album.images.last.slug }
    assert_equal 'You\'ve successfuly updated your cover photo', flash[:success]
  end
end
