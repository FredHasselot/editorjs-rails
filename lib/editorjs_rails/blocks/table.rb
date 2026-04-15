# frozen_string_literal: true

module EditorjsRails
  module Blocks
    class Table < Base
      attr_reader :content, :with_headings

      def initialize(id:, type:, content: [], withHeadings: false, **_rest)
        super(id: id, type: type)
        @content = Array(content)
        @with_headings = withHeadings
      end

      def to_html
        return "" if @content.empty?

        rows = @content.dup
        html = "<table>"

        if @with_headings && rows.any?
          header_row = rows.shift
          html += "<thead><tr>"
          header_row.each { |cell| html += "<th>#{escape_html(cell)}</th>" }
          html += "</tr></thead>"
        end

        html += "<tbody>"
        rows.each do |row|
          html += "<tr>"
          Array(row).each { |cell| html += "<td>#{escape_html(cell)}</td>" }
          html += "</tr>"
        end
        html += "</tbody></table>"
        html
      end

      private

      def validate
        @errors << "content cannot be empty" if @content.empty?
      end

      def data_to_h
        { content: @content, withHeadings: @with_headings }
      end
    end
  end
end
