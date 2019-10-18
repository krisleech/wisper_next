require "bundler/setup"
require "wisper_next"

require 'pry' unless ENV['CI']
require 'securerandom'

RSpec.configure do |config|
  config.order = :random

  config.filter_run_when_matching :focus

  config.example_status_persistence_file_path = ".rspec_status"

  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
