# frozen_string_literal: true

require 'application_system_test_case'

class CommentsTest < ApplicationSystemTestCase
  setup do
    @user = users :maymie
  end

  test 'comment flow' do
    log_in_as @user
    text = 'Happiness is when what you think, what you say, and what you do are in harmony.'
    within all('.commentable')[5] do
      find(:css, 'i.comment.icon').click
      click_link 'Cancel'
      refute_selector 'form[class = \'ui form\']'

      find(:css, 'i.comment.icon').click
      fill_in 'comment[text]', with: text
      click_button 'Comment'
      refute_selector 'form[class = \'ui form\']'
      assert_selector 'div[class = \'ui comments\']'
      within find('div.ui.comments') do
        assert_text text
        assert_text @user.name
      end
    end
    assert_text :all, 'Comment successfuly posted'

    within all('.commentable')[5] do
      within first('div.ui.comments div.comment') do
        click_link 'Delete'
        page.driver.browser.switch_to.alert.accept
        refute_text text
      end
      refute_selector 'div[class = \'ui comments\']'
    end
    assert_text :all, 'Your comment was destroyed'
  end
end
