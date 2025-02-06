# nvim-sessions

A simple session management plugin for Neovim. It uses
[`:mksession`][mksession] to save and [`:source`][source] to load working
directory based sessions.

[mksession]: https://neovim.io/doc/user/starting.html#%3Amksession
[sessionoptions]: https://neovim.io/doc/user/options.html#'sessionoptions'
[source]: https://neovim.io/doc/user/repeat.html#%3Asource

> [!WARNING]
> This plugin is based on my personal needs. Work in progress. 🚀

Other better plugins are:

- [Shatur/neovim-session-manager](https://github.com/Shatur/neovim-session-manager)
- [folke/persistence.nvim](https://github.com/folke/persistence.nvim)
- [tpope/vim-obsession](https://github.com/tpope/vim-obsession)
- [echasnovski/mini.sessions](https://github.com/echasnovski/mini.sessions)
- and many more ...

## Features

- Uses **one** session file per **working directory**
- Session files are stored **global** in `vim.fn.stdpath('data')` in
  a configurable subdirectory
- Sessions are **manually** saved, loaded and deleted
- It ignores empty windows from plugins like nvim-tree or outline<br />
  (removes temporary `blank` from the `:h sessionoptions`)

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
  'tigion/nvim-sessions',
  cmd = 'Session',
  keys = {
    { '<Leader>ws', '<Cmd>Session save<CR>', desc = 'Save session (cwd)' },
    { '<Leader>wl', '<Cmd>Session load<CR>', desc = 'Load session (cwd)' },
  },
  opts = {},
}
```

## Configuration

The default options are:

```lua
{
  -- The name of the subdirectory in `vim.fn.stdpath('data')`
  -- where the sessions are saved.
  -- If it does not exist, it will be created.
  directory = 'sessions', ---@type string

  -- Overwrites existing session files without confirmation.
  overwrite = true, ---@type boolean
}
```

For other plugin manager, call the setup function
`require('sessions').setup({ ... })` directly.

## Usage

| Command           | Description                                                           |
| ----------------- | --------------------------------------------------------------------- |
| `:Session info`   | Shows information about the current session and the `Session` command |
| `:Session save`   | Saves the current session for the current working directory           |
| `:Session load`   | Loads the session for the current working directory                   |
| `:Session delete` | Deletes the session for the current working directory                 |

Run `:checkhealth sessions` to check the health of the plugin.

## TODO

- [x] Move simple session management from tigion.core.util.session to a plugin.
- [x] Update readme
