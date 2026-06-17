# sessions.nvim

A simple session management plugin for Neovim. It uses
[`:mksession`][mksession] to save and [`:source`][source] to load current
working directory based sessions.

[mksession]: https://neovim.io/doc/user/starting.html#%3Amksession
[sessionoptions]: https://neovim.io/doc/user/options.html#'sessionoptions'
[source]: https://neovim.io/doc/user/repeat.html#%3Asource

> [!NOTE]
> This plugin is based on my personal workflow and is still evolving. 🚀

> [!WARNING]
> 17.06.2026: The merged commit
> [8e75111](https://github.com/tigion/sessions.nvim/commit/8e75111024acdd3081242607d89a9562d7c48e71)
> introduced a breaking change.
>
> - The session files have a new format (hash based) and are not compatible
>   with the old ones. Old session files will be ignored and can be deleted.

## Features

- Uses **one** session file per **current working directory**.
- Session files are stored in a configurable subdirectory within
  `vim.fn.stdpath('data')` (default: `sessions`).
- Sessions can be **manually** saved, loaded, and deleted.
- Optionally, sessions are automatically saved when Neovim exits.
- Ignores empty windows from plugins like nvim-tree or outline<br />
  (removes the temporary `blank` option from `:h sessionoptions`). This can be
  configured in the options.

> [!TIP]
> See [`:h sessionoptions`][sessionoptions] to customize what is stored in the
> session file created by `:mksession`.

## Requirements

- Neovim >= 0.10

## Installation

### [vim.pack]

[vim.pack]: https://neovim.io/doc/user/pack/#vim.pack

Requires Neovim >= 0.12.

```lua
vim.pack.add({
  'https://github.com/tigion/sessions.nvim',
})
```

### [lazy.nvim]

[lazy.nvim]: https://github.com/folke/lazy.nvim

```lua
return {
  'tigion/sessions.nvim',
  cmd = 'Session',
}
```

## Configuration

The plugin works out of the box with the [default options](#default-options).

Configure the plugin with `setup()` (optional):

```lua
require('sessions').setup({
  -- Your config here.
})
```

Example keymaps:

```lua
vim.keymap.set('n', '<Leader>ws', '<Cmd>Session save<CR>', { desc = 'Save session (cwd)' })
vim.keymap.set('n', '<Leader>wl', '<Cmd>Session load<CR>', { desc = 'Load session (cwd)' })
```

With `lazy.nvim`, `opts` is passed to `setup()` automatically. Use `opts` for
configuration and `keys` for lazy-loaded keymaps:

```lua
return {
  'tigion/sessions.nvim',
  cmd = 'Session',

  keys = {
    -- Example keymaps:
    { '<Leader>ws', '<Cmd>Session save<CR>', desc = 'Save session (cwd)' },
    { '<Leader>wl', '<Cmd>Session load<CR>', desc = 'Load session (cwd)' },
  },

  ---@module 'sessions'
  ---@type sessions.Config
  opts = {
    -- Your config here.
  },
}
```

### Default options

```lua
---@class sessions.Config
---@field auto_save? boolean Automatically saves the session on Neovim exit.
---@field directory? string The subdirectory in `vim.fn.stdpath('data')` where the sessions are saved.
---@field ignore_blank? boolean Ignores saving sessions for blank buffers.
---@field ignored_filetypes? table<string, boolean> Ignores session saving for the specified filetypes.
---@field notify? boolean Notifies when a session is loaded, saved or deleted.
---@field overwrite? boolean Overwrites existing session files without confirmation.

--- The default options.
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

## Related plugins

- [Shatur/neovim-session-manager](https://github.com/Shatur/neovim-session-manager)
- [folke/persistence.nvim](https://github.com/folke/persistence.nvim)
- [tpope/vim-obsession](https://github.com/tpope/vim-obsession)
- [echasnovski/mini.sessions](https://github.com/echasnovski/mini.sessions)
