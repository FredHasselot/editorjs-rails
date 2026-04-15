# Changelog

## [0.1.0] - 2026-04-15

### Added
- Core document parser (`EditorjsRails::Document`)
- Block registry with 10 built-in block types (paragraph, header, list, quote, delimiter, code, table, image, warning, checklist)
- Custom block registration via `EditorjsRails::BlockRegistry.register`
- Server-side rendering: `render_editorjs` helper
- Form builder: `f.editorjs :body`
- Stimulus controller with EditorJS initialization, JSON serialization, and cleanup
- CSS theming with CSS custom properties + dark mode preset
- Configuration via `EditorjsRails.configure`
- Generators: `editorjs_rails:install` and `editorjs_rails:assets`
- HTML sanitization (XSS prevention) on all text output
- RSpec test suite (93 examples)
