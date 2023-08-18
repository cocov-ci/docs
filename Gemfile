source "https://rubygems.org"
gem "jekyll", "~> 4.3.2"
gem "byebug"

group :jekyll_plugins do
  gem "jekyll-github-metadata"
  gem 'jekyll-redirect-from'
  gem 'jekyll-last-modified-at'
  gem 'jekyll-toc'
end

# Lock `http_parser.rb` gem to `v0.6.x` on JRuby builds since newer versions of the gem
# do not have a Java counterpart.
gem "http_parser.rb", "~> 0.6.0", :platforms => [:jruby]

gem "rouge", "~> 4.1"
