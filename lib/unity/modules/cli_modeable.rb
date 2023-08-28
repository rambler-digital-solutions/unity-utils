# frozen_string_literal: true

require 'ruby-progressbar'

module Unity
  module Modules
    module CliModeable
      private

      # @return [Boolean]
      def cli_mode?
        @cli_mode == true
      end

      # @param amount [Fixnum]
      # @param title [String]
      # @return [void]
      def init_progressbar(amount, title = self.class.to_s)
        return unless cli_mode?

        @progressbar = ProgressBar.create(title: title, format: '%t, %c/%C,%e: |%B|')
        @progressbar.total = amount
      end

      # Increment value of progressbar
      # @return [void]
      def incr_progressbar
        @progressbar.increment if cli_mode?
      end

      # @param amount [Fixnum]
      # @return [void]
      def add_to_progress(amount = 0)
        return unless cli_mode?

        new_progress = @progressbar.progress + amount
        @progressbar.progress = new_progress if new_progress <= @progressbar.total
      end
    end
  end
end
