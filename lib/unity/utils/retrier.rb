# frozen_string_literal: true

module Unity
  module Utils
    class Retrier
      attr_reader :errors, :max_retries, :sleep_factor

      def self.call
        new.call(&Proc.new) if block_given?
      end

      def initialize(errors = nil, max_retries = 5, sleep_factor = 0.3)
        @errors = errors || [StandardError]
        @max_retries = max_retries
        @sleep_factor = sleep_factor
      end

      def call
        return unless block_given?

        retries = 0

        begin
          yield
        rescue *errors => e
          retries += 1
          raise e if retries > max_retries

          sleep_on(retries)
          retry
        end
      end

      private

      def sleep_on(retries)
        sleep((2**retries) * sleep_factor)
      end
    end
  end
end
