source "http://rubygems.org"

# Declare your gem's dependencies in exlibris-primo.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

gem 'jruby-openssl', "~> 0.9.0", platform: :jruby

source 'https://gems.railslts.com' do
  gem 'activesupport', :require => false
end

group :test do
  gem "coveralls", "~> 0.8.23", :require => false
end

platforms :rbx do
  gem 'rubysl', '~> 2.0' # if using anything in the ruby standard library
  gem 'rubinius-coverage'
  gem 'rubysl-test-unit'
  gem "racc"
end
