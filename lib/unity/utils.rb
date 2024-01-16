# frozen_string_literal: true

Dir['*.rb', base: 'lib/unity/modules'].each { |filename| require_relative "modules/#{filename}" }
Dir['*.rb', base: 'lib/unity/utils'].each { |filename| require_relative "utils/#{filename}" }

I18n.load_path += Dir[File.join(File.dirname(__FILE__), 'config/locales/*.yml')]

module Unity
  module Utils
    class Error < StandardError; end
  end
end
