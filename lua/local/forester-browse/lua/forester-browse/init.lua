--- *forester.nvim* Forester filetype plugin
---
--- =========================================================================
---
--- Supported features:
--- - Autocomplete
--- - following links via `gf`
--- - fuzzy finding
---
--- # Setup ~
---
--- Initialize the plugin via `require("forester").setup()`
---
--- In your `forest.toml`, add the list of prefixes you wish to use:
--- >toml
--- prefixes = ["foo", "bar"]
--- <
--- This plugin currently does not support user configuration via lua.
--- I think it is preferrable to use the forester configuration files and
--- extracting the relevant keys via treesitter
---

local commands = require("forester-browse.commands")
local config = require("forester-browse.config")

local M = {}

local function setup()
  local forester_group = vim.api.nvim_create_augroup("ForesterGroup", { clear = true })

  vim.api.nvim_create_user_command("Forester", function(cmd)
    local prefix, args = commands.parse(cmd.args)
    commands.cmd(prefix, args)
  end, {
    bar = true,
    bang = true,
    nargs = "?",
    complete = function(_, line)
      local prefix, args = commands.parse(line)
      if #args > 0 then
        return commands.complete(prefix, args[#args])
      end
      return vim.tbl_filter(function(key)
        return key:find(prefix, 1, true) == 1
      end, vim.tbl_keys(commands.commands))
    end,
  })

  config.set_default_config()
end

M.setup = setup

return M
