# frozen_string_literal: true

module EditorjsRails
  module FormBuilder
    def editorjs(method, placeholder: nil, css_class: nil, dark: false, **options)
      object_value = object&.public_send(method)
      content_json = case object_value
                     when String then object_value
                     when Hash then object_value.to_json
                     else "{}"
                     end

      field_name = "#{object_name}[#{method}]"
      field_id = "#{object_name}_#{method}"
      prefix = EditorjsRails.configuration.css_class_prefix
      wrapper_class = [
        "#{prefix}-field",
        ("#{prefix}-dark" if dark),
        css_class
      ].compact.join(" ")

      placeholder_attr = placeholder || ::I18n.t("editorjs_rails.placeholder")
      content_data = content_json == "{}" ? "{}" : content_json
      i18n_json = EditorjsRails::I18nHelper.messages.to_json

      html = %(<div data-controller="editorjs"
                     data-editorjs-content-value="#{ERB::Util.h(content_data)}"
                     data-editorjs-placeholder-value="#{ERB::Util.h(placeholder_attr)}"
                     data-editorjs-i18n-value="#{ERB::Util.h(i18n_json)}"
                     class="#{wrapper_class}">)
      html += %(<div data-editorjs-target="editor" id="#{field_id}_editor"></div>)
      html += %(<input type="hidden" name="#{field_name}" id="#{field_id}" value="#{ERB::Util.h(content_json)}" data-editorjs-target="input">)
      html += %(</div>)
      html.html_safe
    end
  end
end
