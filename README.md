# sessions.nvim

A simple session management plugin for Neovim. It uses
[`:mksession`][mksession] to save and [`:source`][source] to load working
directory based sessions.

[mksession]: https://neovim.io/doc/user/starting.html#%3Amksession
[sessionoptions]: https://neovim.io/doc/user/options.html#'sessionoptions'
[source]: https://neovim.io/doc/user/repeat.html#%3Asource

> [!WARNING]
> This plugin is based on my personal needs. Work in progress. 🚀
>
> The former name of this plugin was `nvim-sessions`.

Other better plugins are:

- [Shatur/neovim-session-manager](https://github.com/Shatur/neovim-session-manager)
- [folke/persistence.nvim](https://github.com/folke/persistence.nvim)
- [tpope/vim-obsession](https://github.com/tpope/vim-obsession)
- [echasnovski/mini.sessions](https://github.com/echasnovski/mini.sessions)
- and many more ...

## Features

- Uses **one** session file per **working directory**.
- Session files are stored **global** in `vim.fn.stdpath('data')` in
  a configurable subdirectory.
- Sessions can **manually** saved, loaded and deleted.
- Optionally, the session is automatically saved when Neovim is closed.
- It ignores empty windows from plugins like nvim-tree or outline<br />
  (removes temporary `blank` from the `:h sessionoptions`). Can be configured
  in the options.

> [!TIP]
> See [`:h sessionoptions`][sessionoptions] to change what is stored in the
> session file with `:mksession`.

## Requirements

- Neovim >= 0.10

## Installation

### [lazy.nvim]

[lazy.nvim]: https://github.com/folke/lazy.nvim

```lua
return {
  'tigion/sessions.nvim',
  event = 'VeryLazy',
  cmd = 'Session',
  keys = {
    { '<Leader>ws', '<Cmd>Session save<CR>', desc = 'Save session (cwd)' },
    { '<Leader>wl', '<Cmd>Session load<CR>', desc = 'Load session (cwd)' },
  },
  ---@module 'sessions'
  ---@type sessions.Config
  opts = {},
}
```

### vim.pack (nvim 0.12+)

```lua
vim.pack.add({
  'https://github.com/tigion/sessions.nvim',
  -- { src = 'https://github.com/tigion/sessions.nvim', version = 'main' },
})

-- Use `setup()` for your own user configuration in the `{}` table.
require('sessions').setup({
  -- Your config here.
})

-- Add keymaps for session management.
vim.keymap.set('n', '<Leader>ws', '<Cmd>Session save<CR>', { desc = 'Save session (cwd)' })
vim.keymap.set('n', '<Leader>wl', '<Cmd>Session load<CR>', { desc = 'Load session (cwd)' })
```

## Configuration

The default options are:

```lua
---@class sessions.Config
---@field auto_save? boolean Automatically saves the session on Neovim exit.
---@field directory? string The subdirectory in `vim.fn.stdpath('data')` where the sessions are saved.
---@field ignore_blank? boolean Ignores saving sessions for blank buffers.
---@field ignored_filetypes? table<string, boolean> Ignores session saving for the specified filetypes.
---@field notify? boolean Notifies when a session is loaded or saved.
---@field overwrite? boolean Overwrites existing session files without confirmation.

---The default options.
---@type sessions.Config
local defaults = {
  auto_save = false,
  directory = 'sessions', -- Will be created if not available.
  ignore_blank = true,
  ignored_filetypes = { -- Will prevent session saving if found.
    alpha = true,
    dashboard = true,
    snacks_dashboard = true,
  },
  notify = true,
  overwrite = true,
}
```

For other plugin manager, call the setup function
`require('sessions').setup({ ... })` directly.

## Usage

| Command           | Description                                                            |
| ----------------- | ---------------------------------------------------------------------- |
| `:Session info`   | Shows information about the current session and the `Session` command. |
| `:Session save`   | Saves the current session for the current working directory.           |
| `:Session load`   | Loads the session for the current working directory.                   |
| `:Session delete` | Deletes the session for the current working directory.                 |

With `require('sessions').exists()` you can check if a session exists for the
current working directory.

Run `:checkhealth sessions` to check the health of the plugin.

## TODO

- [x] Add lua comment [annotations](https://luals.github.io/wiki/annotations/).
- [x] Add auto save.
- [x] Update readme.
- [x] Move simple session management from tigion.core.util.session to a plugin.
