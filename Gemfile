source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

ruby '2.4.0'

gem 'autoprefixer-rails'
gem 'aws-sdk'
gem 'coffee-rails', '~> 4.2'
gem 'css-class-string'
gem 'devise'
gem 'draper'
gem 'faker'
gem 'figaro'
gem 'haml-rails'
gem 'jbuilder', '~> 2.5'
gem 'jquery-rails', '~> 4.3', '>= 4.3.1'
gem 'jquery-turbolinks'
gem 'kaminari'
gem 'less-rails-semantic_ui'
gem 'omniauth'
gem 'omniauth-facebook'
gem 'paperclip'
gem 'pg', '~> 0.18'
gem 'puma', '~> 3.7'
gem 'pundit'
gem 'rails', '~> 5.1.1'
gem 'redis', '~> 3.0'
gem 'sass-rails', '~> 5.0'
gem 'therubyracer'
gem 'turbolinks', '~> 5'
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
gem 'uglifier', '>= 1.3.0'
gem 'wikipedia-client'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'capybara', '~> 2.13'
  gem "database_cleaner"
  gem 'factory_girl_rails'
  gem 'rspec-rails'
  gem "rubycritic", require: false
  gem 'selenium-webdriver'
end

group :development do
  gem 'bullet'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
end
