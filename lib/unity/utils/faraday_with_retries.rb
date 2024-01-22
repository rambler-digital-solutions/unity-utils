# frozen_string_literal: true

# Faraday connection inintializer.
# It creates `Faraday::Connection` object with pre-defined retries.
module Unity
  module Utils
    require 'faraday'

    class FaradayWithRetries
      DEFAULT_EXCEPTIONS = [
        *(Faraday::Request::Retry::DEFAULT_EXCEPTIONS if defined?(Faraday::Request::Retry)),
        Faraday::TimeoutError, Faraday::ConnectionFailed
      ].freeze

      # @param exceptions [Array<Exception>]
      # @param max [Integer] retries count
      # @param interval [Float] in seconds
      # @param interval_randomness [Float] in seconds
      # @param backoff_factor [Integer] amount to multiplyeach successive retry's interval
      def initialize(exceptions: [], max: 3, interval: 1.0, interval_randomness: 0.1, backoff_factor: 1)
        @exceptions = exceptions.presence || DEFAULT_EXCEPTIONS

        @max = max
        @interval = interval
        @interval_randomness = interval_randomness
        @backoff_factor = backoff_factor
      end

      # @param url [String]
      # @return [Faraday::Connection]
      def call(url)
        Faraday.new(url: url) do |i|
          i.request(:retry,
                    max:                 @max,
                    interval:            @interval,
                    interval_randomness: @interval_randomness,
                    backoff_factor:      @backoff_factor,
                    exceptions:          @exceptions)
          if block_given?
            yield(i)
          else
            i.adapter Faraday.default_adapter
          end
        end
      end
    end
  end
end
