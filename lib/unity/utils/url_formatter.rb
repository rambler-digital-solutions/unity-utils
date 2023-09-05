# frozen_string_literal: true

module Unity
  module Utils
    # Class for formatting link.
    #
    # Usage:
    #  ::Unity::Utils::UrlFormatter.new('blog/post/nykotyn-bez-syharet-hde-on-soderzytsia').params({'erid' => 'test'}).build
    class UrlFormatter
      # @param link [String]
      def initialize(link)
        @link = link
      end

      # @param params [Hash, Array<Array>]
      # @return [Self]
      def params(params)
        @query = build_query(params)

        self
      end

      # @param enabled [Boolean]
      # @return [Self]
      def trailing_slash(enabled: true)
        @trailing_slash = enabled

        self
      end

      # @return [String]
      def build
        uri.query = @query if @query

        uri.to_s
      end

      private

      # @return [URI::Generic]
      def uri
        @uri ||= begin
          link = @link
          link = @link.chomp('/') unless @trailing_slash

          URI.parse(link)
        end
      end

      def build_query(params)
        new_query = URI.decode_www_form(uri.query || '')

        params.each { |k, v| new_query << [k, v] }

        URI.encode_www_form(new_query)
      end
    end
  end
end
