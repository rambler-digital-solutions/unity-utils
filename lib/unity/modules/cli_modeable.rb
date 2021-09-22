# frozen_string_literal: true

require 'ruby-progressbar'

module Unity
  module Modules
    module CliModeable
      private

      def cli_mode?
        @cli_mode == true
      end

      def init_progressbar(amount, title = self.class.to_s)
        return unless cli_mode?

        @progressbar = ProgressBar.create(title: title, format: '%t, %c/%C,%e: |%B|')
        @progressbar.total = amount
      end

      def incr_progressbar
        @progressbar.increment if cli_mode?
      end
    end
  end
end
