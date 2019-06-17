# frozen_string_literal: true

require 'application_system_test_case'

class SearchTest < ApplicationSystemTestCase
  setup do
    @user = users :maymie
    User.reindex
    StatusUpdate.reindex
    Image.reindex
    Comment.reindex
  end

  test 'searching for a term redirects to users search page' do
    log_in_as @user

    within find(:css, 'div.fixed.menu') do
      assert_selector 'form[action = \'/search/users\']'
      fill_in 'q', with: 'Ronny'
      find('input.prompt').native.send_keys(:return)
      assert_current_path '/search/users?utf8=%E2%9C%93&q=Ronny'
    end
    assert_text "Results for 'Ronny'"
    assert_all_of_selectors :link, 'Users', 'Status updates', 'Images', 'Comments'
  end

  test 'searching returns correct results' do
    log_in_as @user

    within find(:css, 'div.fixed.menu') do
      fill_in 'q', with: 'You only live once'
      find('input.prompt').native.send_keys(:return)
    end
    assert_text 'No users'

    click_link 'Status updates'
    assert_selector 'div.ui.segment', count: 1
    assert_text 'You only live once, but if you do it right, once is enough.'
    assert_selector 'a', status_update_path(status_updates(:first))

    click_link 'Images'
    assert_text 'No images'

    click_link 'Comments'
    assert_text 'No comments'
  end
end
