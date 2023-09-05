# frozen_string_literal: true

# Modules
require_relative 'modules/cli_modeable'
require_relative 'modules/entities_log_dump'
require_relative 'modules/flexible_boolean'
require_relative 'modules/loggable'

# Utils
require_relative 'utils/ci_formatter'
require_relative 'utils/retrier'
require_relative 'utils/thread_pool'
require_relative 'utils/url_formatter'
require_relative 'utils/url_validator'

I18n.load_path += Dir[File.join(File.dirname(__FILE__), 'config/locales/*.yml')]

module Unity
  module Utils
    class Error < StandardError; end
  end
end
