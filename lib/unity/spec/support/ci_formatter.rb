# frozen_string_literal: true

require 'rspec/core'

RSpec::Support.require_rspec_core 'formatters/progress_formatter'

class CiFormatter < RSpec::Core::Formatters::ProgressFormatter
  RSpec::Core::Formatters.register self

  def example_pending(_); end

  def dump_pending(_); end
end
