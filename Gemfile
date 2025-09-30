source "https://rubygems.org"

ruby "3.3.4"

gem "bundler", "~> 2.4"
gem "rails", "~> 7.1.4"
gem "sprockets-rails"
gem 'pg', '~> 1.1'
gem 'tailwindcss-rails'
# gem 'kt-paperclip', '~> 7.1', '>= 7.1.1' # COMMENT OUT for first deploy
gem 'devise'
gem "puma", ">= 5.0"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "jbuilder"
gem "tzinfo-data", platforms: %i[windows jruby]
gem "bootsnap", require: false
# gem "image_processing", "~> 1.2" # Leave commented for now
gem 'geocoder'

group :development, :test do
  gem "debug", platforms: %i[mri windows]
end

group :development do
  gem "web-console"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
end
