#!/usr/bin/env rake

begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

require 'rspec/core'
require 'rspec/core/rake_task'

desc 'Run the acceptance tests using Beaker'
RSpec::Core::RakeTask.new(:beaker) do |t|
  t.pattern = 'spec/acceptance/**{,/*/**}/*_spec.rb'
end
