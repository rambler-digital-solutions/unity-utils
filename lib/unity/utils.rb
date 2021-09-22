# frozen_string_literal: true

Dir['./lib/unity/**/**.rb'].sort.each { |file_path| require(file_path) }

module Unity
  module Utils
    class Error < StandardError; end
  end
end
