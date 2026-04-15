# Contributing

## Setup

```bash
git clone git@github.com:fredhasselot/editorjs-rails.git
cd editorjs-rails
bundle install
bundle exec rspec
```

## Adding a new block type

1. Create `lib/editorjs_rails/blocks/my_block.rb` inheriting from `Base`
2. Implement `initialize`, `to_html`, `validate`, `data_to_h`
3. Add `require_relative` in `lib/editorjs_rails.rb`
4. Register in `BlockRegistry.register_defaults`
5. Write specs in `spec/editorjs_rails/blocks/my_block_spec.rb`
6. Add to the supported blocks table in README

## Running tests

```bash
bundle exec rspec
```

## Code style

- Follow existing patterns in the codebase
- PORO blocks: no external dependencies
- All text output must be HTML-escaped (`escape_html`)
- Each block must implement `validate` and `data_to_h`

## Pull requests

- One feature per PR
- Tests required
- Update CHANGELOG.md
