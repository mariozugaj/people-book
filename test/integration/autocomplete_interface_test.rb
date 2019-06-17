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
    results = JSON.parse(response.body)['results']['category1']['results'][0]

    assert_equal results['title'], @friend.name
    assert_equal results['image'], @friend.avatar.url(:thumb)
    assert_equal results['description'], @friend.profile.hometown
    assert_equal results['url'], user_path(@friend)
  end

  test 'autocomplete returns right status update results' do
    log_in_as @user
    get autocomplete_path, params: { q: 'You only live once' }
    results = JSON.parse(response.body)['results']['category1']['results'][0]

    assert_equal results['title'], @status_update.text.truncate(60)
    assert_equal results['image'], @status_update.image.url(:thumb)
    assert_equal results['description'], @status_update.author_name
    assert_equal results['url'], status_update_path(@status_update)
  end

  test 'autocomplete returns right image results' do
    log_in_as @user
    get autocomplete_path, params: { q: 'Blue water' }
    results = JSON.parse(response.body)['results']['category1']['results'][0]

    assert_equal results['title'], @image.description.truncate(60)
    assert_equal results['image'], @image.image.url(:thumb)
    assert_equal results['description'], @image.author_name
    assert_equal results['url'], image_path(@image)
  end

  test 'autocomplete returns right comment results' do
    log_in_as @user
    get autocomplete_path, params: { q: 'To live is the rarest thing' }
    results = JSON.parse(response.body)['results']['category1']['results'][0]

    assert_equal results['title'], @comment.text.truncate(60)
    assert_equal results['image'], @comment.author.avatar.url(:thumb)
    assert_equal results['description'], @comment.author_name
    assert_equal results['url'], status_update_path(@status_update)
  end

  test 'autocomplete friends returns user friends' do
    log_in_as @user
    get autocomplete_friends_path, params: { q: 'Ronny' }
    results = JSON.parse(response.body)['results'][0]

    assert_equal results['title'], @friend.name
    assert_equal results['url'],
                 new_conversation_path(receiver_id: @friend.slug)
  end
end
