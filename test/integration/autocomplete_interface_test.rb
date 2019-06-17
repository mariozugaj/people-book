# frozen_string_literal: true

require 'test_helper'

class AutocompleteInterfaceTest < ActionDispatch::IntegrationTest
  setup do
    @user = users :maymie
    @friend = users :ronny
    @status_update = status_updates :first
    @image = images :first
    @comment = comments :first
  end

  test 'autocomplete returns right user results' do
    log_in_as @user
    get autocomplete_path, params: { q: 'Ronny' }
    assert_equal JSON.parse(response.body)['results']['category1']['results'][0]['title'],
                 @friend.name
    assert_equal JSON.parse(response.body)['results']['category1']['results'][0]['image'],
                 @friend.avatar.url(:thumb)
    assert_equal JSON.parse(response.body)['results']['category1']['results'][0]['description'],
                 @friend.profile.hometown
    assert_equal JSON.parse(response.body)['results']['category1']['results'][0]['url'],
                 user_path(@friend)
  end

  test 'autocomplete returns right status update results' do
    log_in_as @user
    get autocomplete_path, params: { q: 'You only live once' }
    assert_equal JSON.parse(response.body)['results']['category1']['results'][0]['title'],
                 @status_update.text.truncate(60)
    assert_equal JSON.parse(response.body)['results']['category1']['results'][0]['image'],
                 @status_update.image.url(:thumb)
    assert_equal JSON.parse(response.body)['results']['category1']['results'][0]['description'],
                 @status_update.author_name
    assert_equal JSON.parse(response.body)['results']['category1']['results'][0]['url'],
                 status_update_path(@status_update)
  end

  test 'autocomplete returns right image results' do
    log_in_as @user
    get autocomplete_path, params: { q: 'Blue water' }
    assert_equal JSON.parse(response.body)['results']['category1']['results'][0]['title'],
                 @image.description.truncate(60)
    assert_equal JSON.parse(response.body)['results']['category1']['results'][0]['image'],
                 @image.image.url(:thumb)
    assert_equal JSON.parse(response.body)['results']['category1']['results'][0]['description'],
                 @image.author_name
    assert_equal JSON.parse(response.body)['results']['category1']['results'][0]['url'],
                 image_path(@image)
  end

  test 'autocomplete returns right comment results' do
    log_in_as @user
    get autocomplete_path, params: { q: 'To live is the rarest thing' }
    assert_equal JSON.parse(response.body)['results']['category1']['results'][0]['title'],
                 @comment.text.truncate(60)
    assert_equal JSON.parse(response.body)['results']['category1']['results'][0]['image'],
                 @comment.author.avatar.url(:thumb)
    assert_equal JSON.parse(response.body)['results']['category1']['results'][0]['description'],
                 @comment.author_name
    assert_equal JSON.parse(response.body)['results']['category1']['results'][0]['url'],
                 status_update_path(@status_update)
  end

  test 'autocomplete friends returns user friends' do
    log_in_as @user
    get autocomplete_friends_path, params: { q: 'Ronny' }
    assert_equal JSON.parse(response.body)['results'][0]['title'],
                 @friend.name
    assert_equal JSON.parse(response.body)['results'][0]['url'],
                 new_conversation_path(receiver_id: @friend.slug)
  end
end
