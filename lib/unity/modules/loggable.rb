# frozen_string_literal: true

require 'logger'

module Unity
  module Modules
    module Logable
      attr_reader :log_file, :logger

      def clean_logfile
        return if log_file.kind_of?(IO)

        File.open(log_file, 'w') {}
      end

      def puts_log_path
        $stdout.puts("All logs in #{log_file}")
      end

      private

      def exception_to_array(exception)
        [
          "exception=#{exception.class}",
          "msg='#{exception.message}'",
          "backtrace='#{exception.backtrace.first(4).join('; ')}'"
        ]
      end
    end
  end
end
