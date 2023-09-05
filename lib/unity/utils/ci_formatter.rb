# frozen_string_literal: true

require 'rspec/core'
require 'rspec/core/formatters/console_codes'

RSpec::Support.require_rspec_core 'formatters/documentation_formatter'

class CiFormatter < RSpec::Core::Formatters::DocumentationFormatter
  RSpec::Core::Formatters.register self

  DURATION_LONG_FORMAT = '%-80s | Duration: %7.5fs'
  DURATION_SHORT_FORMAT = '%.5fs'
  SHOW_TOP = 20

  def initialize(*args)
    super
    @example_times = []
  end

  def example_started(*_args)
    @time = Time.zone.now
  end

  def example_passed(notification)
    super

    @example_times << [
      notification.example.file_path,
      notification.example.example_group.description,
      notification.example.description,
      Time.zone.now - @time
    ]
  end

  def failure_output(example)
    RSpec::Core::Formatters::ConsoleCodes.wrap(
      format(DURATION_LONG_FORMAT,
             "#{current_indentation}#{example.description.strip} (FAILED - #{next_failure_index})",
             example.execution_result[:run_time]),
      :failure
    )
  end

  def passed_output(example)
    RSpec::Core::Formatters::ConsoleCodes.wrap(
      format(DURATION_LONG_FORMAT,
             "#{current_indentation}#{example.description.strip}",
             Time.zone.now - @time),
      :success
    )
  end

  def dump_summary(summary_notification)
    dump_group_times
    dump_example_times

    @output.flush

    super
  end

  def example_pending(_); end

  def dump_pending(_); end

  private

  def dump_example_times
    @output.puts "\n\nSingle examples:\n"

    sorted_by_time(@example_times)[0..SHOW_TOP].each do |file_path, group, example, time|
      @output.puts "#{format(DURATION_SHORT_FORMAT, time)} #{file_path} (#{group} / #{example})"
    end
  end

  def dump_group_times
    @output.puts "\n\nGroups:\n"

    group_times = Hash.new(0)
    @example_times.each do |file_path, group, _example, time|
      group_times["#{file_path} (#{group})"] += time
    end

    sorted_by_time(group_times)[0..SHOW_TOP].each do |group, time|
      @output.puts "#{format(DURATION_SHORT_FORMAT, time)} #{group}"
    end
  end

  # sorted by last ascending
  def sorted_by_time(times)
    times.to_a.sort_by(&:last).reverse
  end
end
