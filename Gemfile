# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

ruby '2.6.5'

gem 'autoprefixer-rails', '~> 9.8'
gem 'annotate', '~> 3.1'
gem 'carrierwave', '~> 1.3', '>= 1.3.1'
gem 'carrierwave-aws', '~> 1.3'
gem 'css-class-string', '~> 0.1.1'
gem 'devise', '~> 4.7'
gem 'faker', '~> 2.13'
gem 'figaro', '~> 1.1', '>= 1.1.1'
gem 'gemoji', '~> 3.0', '>= 3.0.1'
gem 'haml-rails', '~> 2.0', '>= 2.0.1'
gem 'httparty', '~> 0.17.0'
gem 'jbuilder', '~> 2.9', '>= 2.9.1'
gem 'jquery-rails', '~> 4.3', '>= 4.3.5'
gem 'kaminari', '~> 1.2'
gem 'mini_magick', '~> 4.9'
gem 'mini_racer', '~> 0.3.1'
gem 'omniauth', '~> 1.9'
gem 'omniauth-facebook', '~> 8.0'
gem 'omniauth-rails_csrf_protection', '~> 0.1'
gem 'newrelic_rpm', '~> 6.14'
gem 'pg', '~> 1.1', '>= 1.1.4'
gem 'pry', '~> 0.13.1'
gem 'pry-byebug', '~> 3.7'
gem 'pry-rails', '~> 0.3.9'
gem 'puma', '~> 5.3'
gem 'pundit', '~> 2.1'
gem 'rails', '~> 5.2'
gem 'redis', '~> 4.2'
gem 'sass-rails', '~> 5.0', '>= 5.0.7'
gem 'searchkick', '~> 4.0', '>= 4.0.2'
gem 'semantic-ui-sass', '~> 2.4', '>= 2.4.2.0'
gem 'stateful_enum', '~> 0.6.0'
gem 'stringex', '~> 2.8', '>= 2.8.5'
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
gem 'uglifier', '~> 4.1', '>= 4.1.20'
gem 'wikipedia-client', '~> 1.10'

group :development, :test do
  gem 'active_record_query_trace', '~> 1.6', '>= 1.6.2'
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'capybara', '~> 3.33'
  gem 'letter_opener', '~> 1.7'
  gem 'rubycritic', '~> 4.1', require: false
  gem 'selenium-webdriver', '~> 3.142', '>= 3.142.3'
end

group :development do
  gem 'bullet', '~> 6.1'
  gem 'listen', '~> 3.1', '>= 3.1.5'
  gem 'rack-mini-profiler', '~> 2.3'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0', '>= 2.0.1'
  gem 'web-console', '>= 3.3.0'
end
