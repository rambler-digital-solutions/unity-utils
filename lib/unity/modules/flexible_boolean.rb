# frozen_string_literal: true

require 'active_support/concern'

module Unity
  module Modules
    # Concern to make easier work with virtual boolean attributes.
    # Allows always store a boolean value in a pseudo attribute
    # (pass string or boolean, attribute will boolean value type always).
    #
    # Overrides target attribute setter method by adding a
    # comparison of the boolean attribute value with the 'true' string.
    #
    # Usage example:
    #   flexible_boolean :is_reactable
    #
    module FlexibleBoolean
      extend ::ActiveSupport::Concern

      class_methods do
        # @param attribute [Symbol, String]
        # @return [Symbol] defined method name
        def flexible_boolean(attribute)
          define_method(:"#{attribute}=") { |v| super(v.to_s == 'true') }
        end
      end
    end
  end
end
