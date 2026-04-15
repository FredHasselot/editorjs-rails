# frozen_string_literal: true

module EditorjsRails
  module Blocks
    class Checklist < Base
      attr_reader :items

      def initialize(id:, type:, items: [], **_rest)
        super(id: id, type: type)
        @items = Array(items).map do |item|
          if item.is_a?(Hash)
            { text: (item["text"] || item[:text]).to_s, checked: !!(item["checked"] || item[:checked]) }
          else
            { text: item.to_s, checked: false }
          end
        end
      end

      def to_html
        items_html = @items.map do |item|
          checked = item[:checked] ? " checked" : ""
          %(<li><input type="checkbox" disabled#{checked}> #{sanitize_inline(item[:text])}</li>)
        end.join
        %(<ul class="editorjs-checklist">#{items_html}</ul>)
      end

      private

      def validate
        @errors << "items cannot be empty" if @items.empty?
      end

      def data_to_h
        { items: @items }
      end
    end
  end
end
