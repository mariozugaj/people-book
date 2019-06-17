# frozen_string_literal: true

require 'application_system_test_case'

class LikesTest < ApplicationSystemTestCase
  setup do
    @user = users :maymie
  end

  test 'status update like/unlike flow' do
    log_in_as @user
    within all('.commentable')[2] do
      find(:css, 'i.like.icon').click
      assert_selector 'span.likes_count', text: '1 like'
    end
    assert_text 'You liked it!'

    within all('.commentable')[2] do
      find(:css, 'i.like.icon').click
      assert_selector 'span.likes_count', text: '0 likes'
    end
    assert_text 'You dont\' like it anymore'
  end

  test 'comment like/unlike flow' do
    log_in_as @user
    visit user_path(@user)

    within first('.commentable') do
      find(:css, 'a.comments_count').click
      within find(:css, 'div.ui.comments div.comment') do
        find(:css, 'i.like.icon').click
        assert_selector 'a[class = \'likes count\']', text: '1 like'
      end
    end
    assert_text 'You liked it!'

    within first('.commentable') do
      find(:css, 'a.comments_count').click
      within find(:css, 'div.ui.comments div.comment') do
        find(:css, 'i.like.icon').click
        assert_selector 'a[class = \'likes count\']', text: '0 likes'
      end
    end
    assert_text 'You dont\' like it anymore'
  end
end
