require 'overcommit'
require 'tempfile'

hook_types = Dir[File.join(Overcommit::OVERCOMMIT_HOME, 'lib/overcommit/hook/*')].
  select { |f| File.directory?(f) }.
  sort

hook_types.each do |hook_type|
  require File.join(hook_type, 'base.rb')
  Dir[File.join(hook_type, '**/*.rb')].
    select { |f| File.file?(f) && File.basename(f, '.rb') != 'base' }.
    sort.
    each { |f| require f }
end

Dir[File.dirname(__FILE__) + '/support/**/*.rb'].each { |f| require f }

RSpec.configure do |config|
  config.include GitSpecHelpers
  config.include OutputHelpers
  config.include ShellHelpers

  # Continue to enable the older `should` syntax for expectations
  config.expect_with :rspec do |c|
    c.syntax = [:expect, :should]
  end

  config.mock_with :rspec do |c|
    c.syntax = :should
  end
end
