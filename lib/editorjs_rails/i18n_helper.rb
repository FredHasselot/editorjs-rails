# frozen_string_literal: true

module EditorjsRails
  module I18nHelper
    class << self
      def messages
        t = ->(key) { ::I18n.t("editorjs_rails.i18n.#{key}") }

        {
          ui: {
            "blockTunes" => {
              "toggler" => {
                "Click to tune" => t.call("ui.block_tunes.toggler")
              }
            },
            "inlineToolbar" => {
              "converter" => {
                "Convert to" => t.call("ui.inline_toolbar.converter")
              }
            },
            "toolbar" => {
              "toolbox" => {
                "Add" => t.call("ui.toolbar.toolbox")
              },
              "popover" => {
                "Filter" => t.call("ui.toolbar.popover.filter"),
                "Nothing found" => t.call("ui.toolbar.popover.nothing_found")
              }
            }
          },
          toolNames: {
            "Text" => t.call("tool_names.text"),
            "Heading" => t.call("tool_names.heading"),
            "List" => t.call("tool_names.list"),
            "Ordered List" => t.call("tool_names.ordered_list"),
            "Unordered List" => t.call("tool_names.unordered_list"),
            "Checklist" => t.call("tool_names.checklist"),
            "Quote" => t.call("tool_names.quote"),
            "Delimiter" => t.call("tool_names.delimiter"),
            "Code" => t.call("tool_names.code"),
            "Table" => t.call("tool_names.table"),
            "Image" => t.call("tool_names.image"),
            "Warning" => t.call("tool_names.warning"),
            "Bold" => t.call("tool_names.bold"),
            "Italic" => t.call("tool_names.italic"),
            "Link" => t.call("tool_names.link"),
            "Marker" => t.call("tool_names.marker")
          },
          tools: {
            "header" => {
              "Heading 2" => t.call("tools.header.heading_2"),
              "Heading 3" => t.call("tools.header.heading_3"),
              "Heading 4" => t.call("tools.header.heading_4")
            },
            "list" => {
              "Ordered" => t.call("tools.list.ordered"),
              "Unordered" => t.call("tools.list.unordered"),
              "Start with" => t.call("tools.list.start_with"),
              "Counter type" => t.call("tools.list.counter_type")
            },
            "quote" => {
              "Enter a quote" => t.call("tools.quote.enter_a_quote"),
              "Enter a caption" => t.call("tools.quote.enter_a_caption")
            },
            "link" => {
              "Add a link" => t.call("tools.link.add_a_link")
            }
          },
          blockTunes: {
            "delete" => {
              "Delete" => t.call("block_tunes.delete.delete"),
              "Click to delete" => t.call("block_tunes.delete.click_to_delete")
            },
            "moveUp" => {
              "Move up" => t.call("block_tunes.move_up")
            },
            "moveDown" => {
              "Move down" => t.call("block_tunes.move_down")
            }
          }
        }
      end
    end
  end
end
