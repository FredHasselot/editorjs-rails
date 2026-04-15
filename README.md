# editorjs-rails

EditorJS integration for Ruby on Rails. Block-based content editing with server-side rendering, Stimulus controller, form builder, and dark mode theming.

**Zero external Ruby dependencies** beyond Rails itself. Each EditorJS block is a plain Ruby object (PORO) that validates itself and renders to HTML.

## Installation

Add to your Gemfile:

```ruby
gem "editorjs-rails"
```

Run the generators:

```bash
rails g editorjs_rails:install   # Creates config/initializers/editorjs_rails.rb
rails g editorjs_rails:assets    # Copies Stimulus controller + CSS to your app
```

Install the npm packages:

```bash
npm install @editorjs/editorjs @editorjs/header @editorjs/list @editorjs/quote @editorjs/delimiter
```

Register the Stimulus controller in `app/javascript/controllers/index.js`:

```javascript
import EditorjsController from "./editorjs_controller"
application.register("editorjs", EditorjsController)
```

Import the stylesheet in your CSS:

```css
@import "editorjs";
```

## Usage

### Form builder

In any `form_with` or `form_for`:

```erb
<%= form_with(model: @article) do |f| %>
  <%= f.editorjs :body %>
  <%= f.submit %>
<% end %>
```

Options:

```erb
<%= f.editorjs :body,
    placeholder: "Start writing...",
    dark: true,
    css_class: "my-custom-class" %>
```

The field generates:
- A `<div>` with `data-controller="editorjs"` for the Stimulus controller
- An editor container `<div>` where EditorJS renders
- A hidden `<input>` that receives the JSON on form submit

### Rendering content

In your views:

```erb
<%= render_editorjs(@article.body) %>
```

Options:

```erb
<%= render_editorjs(@article.body, wrapper_tag: :article, css_class: "prose") %>
```

The helper accepts a JSON string, a Hash, or an `EditorjsRails::Document` instance.

### Programmatic usage

```ruby
doc = EditorjsRails::Document.new(json_string_or_hash)

doc.valid?      # => true/false
doc.errors      # => ["Block 0 (header): text cannot be blank"]
doc.to_html     # => "<h2>Title</h2>\n<p>Content</p>"
doc.to_h        # => { time: ..., version: ..., blocks: [...] }
doc.blocks      # => [#<EditorjsRails::Blocks::Header>, ...]
```

## Configuration

In `config/initializers/editorjs_rails.rb`:

```ruby
EditorjsRails.configure do |config|
  # Sanitize HTML output (default: true)
  config.sanitize = true

  # CSS class prefix for rendered blocks (default: "editorjs")
  config.css_class_prefix = "editorjs"

  # Wrapper tag for render_editorjs helper (default: :div)
  config.wrapper_tag = :div

  # Register custom block types
  config.register_block("alert", MyApp::AlertBlock)
end
```

## Supported blocks

| Block | EditorJS Tool | HTML Output |
|-------|--------------|-------------|
| Paragraph | built-in | `<p>` |
| Header | `@editorjs/header` | `<h1>` to `<h6>` |
| List | `@editorjs/list` | `<ul>` / `<ol>` with nested support |
| Quote | `@editorjs/quote` | `<blockquote>` with `<cite>` |
| Delimiter | `@editorjs/delimiter` | `<hr>` |
| Code | `@editorjs/code` | `<pre><code>` |
| Table | `@editorjs/table` | `<table>` with optional `<thead>` |
| Image | `@editorjs/image` | `<figure>` + `<img>` + `<figcaption>` |
| Warning | `@editorjs/warning` | `<div>` with title + message |
| Checklist | `@editorjs/checklist` | `<ul>` with disabled checkboxes |

All text content is HTML-escaped to prevent XSS. Unknown block types are silently skipped.

## Custom blocks

Create a class inheriting from `EditorjsRails::Blocks::Base`:

```ruby
class MyApp::AlertBlock < EditorjsRails::Blocks::Base
  attr_reader :message, :level

  def initialize(id:, type:, message: "", level: "info", **_rest)
    super(id: id, type: type)
    @message = message.to_s
    @level = level.to_s
  end

  def to_html
    %(<div class="alert alert-#{escape_html(level)}">#{escape_html(message)}</div>)
  end

  private

  def validate
    @errors << "message cannot be blank" if @message.strip.empty?
  end

  def data_to_h
    { message: @message, level: @level }
  end
end
```

Register it in your initializer:

```ruby
EditorjsRails.configure do |config|
  config.register_block("alert", MyApp::AlertBlock)
end
```

## Dark mode

The included CSS uses CSS custom properties. Add the `editorjs-dark` class to enable the dark preset:

```erb
<%= f.editorjs :body, dark: true %>
```

Or override the variables in your stylesheet to match your design system:

```css
:root {
  --editorjs-bg: #1a1a2e;
  --editorjs-text: #eaeaea;
  --editorjs-border: #333;
  --editorjs-toolbar-bg: #16213e;
  --editorjs-toolbar-text: #ccc;
  --editorjs-toolbar-hover: #1a1a2e;
  --editorjs-link: #4ea8de;
}
```

## Requirements

- Ruby >= 3.1
- Rails >= 7.0
- Node.js (for EditorJS npm packages)
- esbuild, webpack, or any JS bundler

## License

MIT License. See [LICENSE.txt](LICENSE.txt).
