# frozen_string_literal: true

require 'minitest/test_task'
require 'rubocop/rake_task'

Minitest::TestTask.create
task default: %i[lint test]

task :run do
  ruby 'lib/dec-18/main.rb'
end

RuboCop::RakeTask.new(:lint) do |task|
  task.patterns = ['Gemfile', 'Rakefile', 'lib/**/*.rb', 'test/**/*.rb']
  task.fail_on_error = true
end
