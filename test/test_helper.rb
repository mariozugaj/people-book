require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'support/fixture_file_helpers'
require 'support/omniauth_helpers.rb'
require 'minitest/autorun'


class ActiveSupport::TestCase
  fixtures :all
  include OmniauthHelper
  OmniAuth.config.test_mode = true
  Searchkick.disable_callbacks

  require 'fileutils'

  carrierwave_template = Rails.root.join('test', 'fixtures', 'files')
  carrierwave_root = Rails.root.join('test', 'support', 'carrierwave')

  CarrierWave.configure do |config|
    config.root = carrierwave_root
    config.enable_processing = false
    config.storage = :file
    config.cache_dir = Rails.root.join('test', 'support', 'carrierwave', 'carrierwave_cache')
  end

  FileUtils.cp_r carrierwave_template.join('uploads'), carrierwave_root

  at_exit do
    Dir.glob(carrierwave_root.join('*')).each do |dir|
      FileUtils.remove_entry(dir)
    end
  end
end

