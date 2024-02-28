# frozen_string_literal: true

require 'rspec/core'

# https://test-prof.evilmartians.io/profilers/tag_prof?id=pro-tip-more-types
RSpec.configure do |config|
  config.define_derived_metadata(file_path: %r{/spec/}) do |metadata|
    # do not overwrite type if it's already set
    next if metadata.key?(:type)

    match = metadata[:location].match(%r{/spec/([^/]+)/})
    metadata[:type] = match[1].singularize.to_sym
  end
end
