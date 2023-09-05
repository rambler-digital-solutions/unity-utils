# frozen_string_literal: true

require 'active_support/concern'

module Unity
  module Modules
    # You could use this module for service objects
    #   class YourServiceObject
    #     include Helpers::EntitiesLogDump
    #
    # You can get array of logged entities by custom attributes like that:
    #     def topic_query
    #       @topic_query ||= Topic.first(2)
    #     end
    #
    #     def foo
    #       dump_entities(topic_query, attributes: [:id, :headline])
    #     end
    #  Result: [{ "id" => 1, "headline" => "foo" }, { "id" => 2, "headline" => "bar" }]
    #
    module EntitiesLogDump
      extend ::ActiveSupport::Concern

      # @param entities [ActiveRecord::Relation,Array<Mongoid::Document>]
      # @param [Hash] options
      # @option options [Array<Symbol>] :attributes
      # @option options [Integer] :batch_size
      # @return [Array<Hash>]
      def dump_entities(entities, options = {})
        attributes = options[:attributes] || all_attributes(entities.first)
        batch_size = options[:batch_size] || 100

        dump_entities = []
        entities.each_slice(batch_size) do |sliced_entities|
          sliced_entities.each do |entity|
            dump_entities.append(dump_entity(entity, attributes: attributes))
          end
        end

        dump_entities
      end

      # @param entity [ApplicationRecord,Mongoid::Document]
      # @param [Hash] options
      # @option options [Array<Symbol>] :attributes
      # @return [Hash]
      def dump_entity(entity, options = {})
        attributes = options[:attributes] || all_attributes(entity)
        attributes.map { |a| { a => try_array(entity.send(a)) } }.inject(:merge).deep_stringify_keys
      end

      # @param entity [ApplicationRecord,Mongoid::Document]
      # @return [Array<String,Symbol>]
      def all_attributes(entity)
        return entity.class.attribute_names if object_is_a?(entity, 'ApplicationRecord')
        return entity.fields.keys if object_is_a?(entity, 'Mongoid::Document')

        raise ArgumentError, "Can't determine full attributes list for this kind of entity."
      end

      private

      # @item [Object]
      # @return
      def try_array(item)
        return item.map { |i| i.try(:attributes) || i } if item.is_a?(Array)
        return item.map(&:attributes) if item.try(:any?) { |obj| object_is_a?(obj, 'ActiveRecord::Base') }

        item
      end

      # @param obj [Object]
      # @klass_name [String]
      # @return [Boolean]
      def object_is_a?(obj, klass_name)
        ancestors = obj.class.ancestors.map(&:to_s)
        ancestors.include?(klass_name)
      end
    end
  end
end
