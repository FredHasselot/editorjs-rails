# frozen_string_literal: true

module EditorjsRails
  module Helper
    def render_editorjs(json_or_hash, wrapper_tag: nil, css_class: nil)
      return "" if json_or_hash.nil?

      doc = json_or_hash.is_a?(EditorjsRails::Document) ? json_or_hash : EditorjsRails::Document.new(json_or_hash)
      tag = wrapper_tag || EditorjsRails.configuration.wrapper_tag
      prefix = EditorjsRails.configuration.css_class_prefix
      klass = css_class || "#{prefix}-content"

      inner_html = doc.to_html
      %(<#{tag} class="#{klass}">#{inner_html}</#{tag}>).html_safe
    end
  end
end
