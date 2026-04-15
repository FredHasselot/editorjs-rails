# frozen_string_literal: true

module EditorjsRails
  module Blocks
    class Image < Base
      attr_reader :url, :caption, :with_border, :stretched, :with_background

      def initialize(id:, type:, url: nil, file: nil, caption: "", withBorder: false, stretched: false, withBackground: false, **_rest)
        super(id: id, type: type)
        @url = url || (file.is_a?(Hash) ? (file["url"] || file[:url]) : nil)
        @caption = caption.to_s
        @with_border = withBorder
        @stretched = stretched
        @with_background = withBackground
      end

      def to_html
        return "" if @url.nil? || @url.to_s.strip.empty?

        classes = css_classes
        html = %(<figure#{classes}>)
        html += %(<img src="#{escape_html(url)}" alt="#{escape_html(caption)}">)
        html += %(<figcaption>#{escape_html(caption)}</figcaption>) unless @caption.strip.empty?
        html += %(</figure>)
        html
      end

      private

      def validate
        @errors << "url cannot be blank" if @url.nil? || @url.to_s.strip.empty?
      end

      def data_to_h
        { url: @url, caption: @caption, withBorder: @with_border, stretched: @stretched, withBackground: @with_background }
      end

      def css_classes
        classes = []
        classes << "editorjs-image--bordered" if @with_border
        classes << "editorjs-image--stretched" if @stretched
        classes << "editorjs-image--background" if @with_background
        classes.any? ? %( class="#{classes.join(" ")}") : ""
      end
    end
  end
end
