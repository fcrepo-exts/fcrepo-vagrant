#!/bin/sh

export BUNDLE_GEMFILE=spec/Gemfile
/usr/bin/env bundle install --gemfile=spec/Gemfile && /usr/bin/env bundle exec rake -f spec/Rakefile beaker
