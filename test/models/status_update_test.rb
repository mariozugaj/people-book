# frozen_string_literal: true

require 'test_helper'

class StatusUpdateTest < ActiveSupport::TestCase
  def setup
    @status_update = status_updates(:first)
  end

  test 'should be valid' do
    assert @status_update.valid?
  end

  test 'text or image should be present' do
    @status_update.text = nil
    @status_update.image = nil
    refute @status_update.valid?
  end
end
