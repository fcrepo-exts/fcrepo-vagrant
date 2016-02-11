#!/bin/sh

/usr/bin/env bundle install && /usr/bin/env bundle exec rake -f spec/Rakefile beaker
