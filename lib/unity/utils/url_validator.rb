# frozen_string_literal: true

require 'uri'
require 'active_support'
require 'active_support/core_ext'

module Unity
  module Utils
    class UrlValidator
      # @!method url
      #   @return [String]
      # @!method validation_errors
      #   @return [Array<String>]
      # @!method response
      #   @return [Response]
      attr_reader :url, :validation_errors, :response

      DEFAULT_LOCALE_PREFIX = 'unity_utils.errors'
      VALID_PROTOCOLS       = [::URI::HTTP, ::URI::HTTPS].freeze
      VALIDATION_METHODS    = %i[blank_url! parse_uri! blank_host! valid_protocol!].freeze

      # @param url [String]
      # @param custom_validation_errors [Hash{Symbol->String}]
      def initialize(url, custom_validation_errors = {})
        @url               = url # krang or site url
        @validation_errors = default_validation_errors.merge(custom_validation_errors).with_indifferent_access
        @response          = Response.new
      end

      # @return [Response]
      def call
        VALIDATION_METHODS.each do |method|
          return response if response.invalid?

          send(method)
        end
        response
      end

      private

      # @return [Hash{Symbol->Sting}]
      def default_validation_errors
        {
          blank_url!:      "#{DEFAULT_LOCALE_PREFIX}.blank_url",
          parse_uri!:      "#{DEFAULT_LOCALE_PREFIX}.invalid_url_format",
          blank_host!:     "#{DEFAULT_LOCALE_PREFIX}.blank_host",
          valid_protocol!: "#{DEFAULT_LOCALE_PREFIX}.invalid_protocol"
        }
      end

      # @param method_name [Symbol]
      # @return [NilClass]
      def add_error(method_name)
        error_message = I18n.t(validation_errors[method_name])

        response.add_error(error_message)
      end

      # @return [NilClass, Array<NilClass, String>]
      def blank_url!
        add_error(__method__) if url.blank?
      end

      # @return [URI::HTTPS, Array<NilClass, String>]
      def parse_uri!
        @uri = ::URI.parse(url)
      rescue ::URI::InvalidURIError
        add_error(__method__)
      end

      # @return [NilClass, Array<NilClass, String>]
      def blank_host!
        add_error(__method__) if @uri.host.nil?
      end

      # @return [NilClass, Array<NilClass, String>]
      def valid_protocol!
        return unless VALID_PROTOCOLS.none? { |protocol| @uri.is_a?(protocol) }

        add_error(__method__)
      end

      class Response
        def initialize
          @errors = []
        end

        # @return [Boolean]
        def valid?
          errors.empty?
        end

        # @return [Boolean]
        def invalid?
          !valid?
        end

        # @return [Array<String>]
        def errors
          @errors.compact
        end

        # @param error [String]
        # @return [Array<String>]
        def add_error(error)
          @errors << error
        end
      end
    end
  end
end
