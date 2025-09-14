# Devenv Starter for developing C

A simple setup to comfortably write small programs in c.

Currently only tested on macOS.

## Dependencies

- [devenv](https://devenv.sh/getting-started/)
- [direnv](https://direnv.net/) for [automatic shell activation]

Devenv will handle everything else.

## Commands

- `just run [path/to/file.c]`: build and run, defaults to `src/main.c`
- `just build [path/to/file.c]`: build, defaults to `src/main.c`
- `just test [filter]`: builds and runs all files in `test/`, filter defaults to `.` and can take any filter that `fd` understands, eg.: `just test example`
- `just watch <...>`: runs `just <...>` on any file change, eg.: `just watch test example`

They work in any directory within the devenv shell.

## Using neovim 

tip: If you started `nvim` from within the devenv shell, then you can quickly
build and run anything via `:!`, eg to run a test `:!just run`.

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
