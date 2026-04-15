# frozen_string_literal: true

require "erb"

module EditorjsRails
  module Blocks
    class Base
      attr_reader :id, :type, :errors

      def initialize(id:, type:, **_data)
        @id = id
        @type = type
        @errors = []
      end

      def valid?
        @errors = []
        validate
        @errors.empty?
      end

      def to_html
        raise NotImplementedError, "#{self.class}#to_html must be implemented"
      end

      def to_h
        { id: @id, type: @type, data: data_to_h }
      end

      private

      def validate
        # Override in subclasses
      end

      def data_to_h
        raise NotImplementedError, "#{self.class}#data_to_h must be implemented"
      end

      def escape_html(str)
        ERB::Util.h(str.to_s)
      end
    end
  end
end
