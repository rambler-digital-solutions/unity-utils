# frozen_string_literal: true

Dir['./lib/unity/**/**.rb'].sort.each { |file_path| require(file_path) }
Dir['./spec/support/**/**.rb'].sort.each { |file_path| require(file_path) }

RSpec.configure do |config|
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
