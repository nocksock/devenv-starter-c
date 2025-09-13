# Devenv Starter for developing C

Currently only test for macOS.

## Dependencies

- [devenv](https://devenv.sh/getting-started/)
- [direnv](https://direnv.net/) for [automatic shell activation]

Devenv will handle everything else.

## Commands

- `dev-build`: build 
- `dev-run`: build and run

They work in any directory within the devenv shell.

## Using neovim 

tip: If you started `nvim` from within the devenv shell, then you can quickly
build and run using `:!dev-run`.

### LSP Config

This is what I currently have in [my config]

```lua
require "lspconfig".clangd.setup({
  cmd = { "clangd", "--background-index", "--clang-tidy" },
  init_options = {
    clangdFileStatus = true
  },
})
```

[my config]: https://github.com/nocksock/dotfiles/blob/main/nvim/after/plugin/lsp/clangd.lua
[automatic shell activation]: https://devenv.sh/automatic-shell-activation/
