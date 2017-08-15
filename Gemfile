source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

ruby '2.4.0'

gem 'annotate', '~> 2.7', '>= 2.7.2'
gem 'autoprefixer-rails', '~> 7.1', '>= 7.1.2.4'
gem 'aws-sdk', '~> 2.10', '>= 2.10.21'
gem 'carrierwave', '~> 1.1'
gem 'carrierwave-aws', '~> 1.2'
gem 'css-class-string', '~> 0.1.1'
gem 'devise', '~> 4.3'
gem 'faker', '~> 1.8', '>= 1.8.4'
gem 'figaro', '~> 1.1', '>= 1.1.1'
gem 'gemoji', '~> 3.0'
gem 'haml-rails', '~> 1.0'
gem 'jbuilder', '~> 2.5'
gem 'jquery-rails', '~> 4.3', '>= 4.3.1'
gem 'kaminari', '~> 1.0', '>= 1.0.1'
gem 'mini_magick', '~> 4.8'
gem 'omniauth', '~> 1.6', '>= 1.6.1'
gem 'omniauth-facebook', '~> 4.0'
gem 'pg', '~> 0.18'
gem 'pry', '~> 0.10.4'
gem 'pry-byebug', '~> 3.4', '>= 3.4.2'
gem 'pry-rails', '~> 0.3.6'
gem 'pundit', '~> 1.1'
gem 'rack-mini-profiler', '~> 0.10.5'
gem 'rails', '~> 5.1.1'
gem 'redis', '~> 3.0'
gem 'rest-client', '~> 2.0', '>= 2.0.2'
gem 'sass-rails', '~> 5.0'
gem 'searchkick', '~> 2.3', '>= 2.3.1'
gem 'semantic-ui-sass', git: 'https://github.com/doabit/semantic-ui-sass.git'
gem 'stringex', '~> 2.7', '>= 2.7.1'
gem 'therubyracer', '~> 0.12.3'
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
gem 'uglifier', '>= 1.3.0'
gem 'wikipedia-client', '~> 1.7'

group :development, :test do
  gem 'active_record_query_trace', '~> 1.5', '>= 1.5.4'
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'capybara', '~> 2.13'
  gem 'database_cleaner', '~> 1.6', '>= 1.6.1'
  gem 'factory_girl_rails', '~> 4.8'
  gem 'letter_opener', '~> 1.4', '>= 1.4.1'
  gem 'rspec-rails', '~> 3.6'
  gem 'rubycritic', '~> 3.2', '>= 3.2.3', require: false
  gem 'selenium-webdriver', '~> 3.4', '>= 3.4.4'
end

group :development do
  gem 'bullet', '~> 5.6', '>= 5.6.1'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
end

group :production do
  gem 'puma', '~> 3.7'
end
