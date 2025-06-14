local Forester = require("forester-browse.bindings")
local config = require("forester-browse.config")
local pickers = require("forester-browse.fzf")
local M = {}

M.commands = {
  -- Select the forester configuration file to use
  -- config = function()
  --   local configs = config.all_configs()
  --   if #configs == 0 then
  --     vim.notify("No forester configs available in the current directory!", vim.log.levels.WARN)
  --   else
  --     pickers.pick_config(configs)
  --     vim.api.nvim_exec_autocmds("User", { pattern = "SwitchedForesterConfig" })
  --   end
  --   -- config.switch()
  -- end,

  browse = function()
    local trees = Forester.query_all(vim.g.forester_current_config.path)
    local t = {}
    for k, v in pairs(trees) do
      v.addr = k
      table.insert(t, v)
    end
    if #t == 0 then
      do
        vim.print("No trees found!")
      end
    end
    pickers.pick_by_title({})
  end,
}

function M.parse(args)
  local parts = vim.split(vim.trim(args), "%s+")
  if parts[1]:find("Forester") then
    table.remove(parts, 1)
  end

  if args:sub(-1) == " " then
    parts[#parts + 1] = ""
  end
  return table.remove(parts, 1) or "", parts
end

function M.cmd(cmd, args)
  local command = M.commands[cmd]
  if command == nil then
    vim.print("Invalid forester command '" .. cmd .. "'")
  elseif cmd == "config" then
    command()
  else
    local current_cfg = vim.g.forester_current_config
    if current_cfg == "" or current_cfg == vim.NIL or current_cfg == nil then
      vim.notify("No forester config file is set! Use `:Forester config` to select one", vim.log.levels.WARN)
    elseif vim.fn.executable("forester") ~= 1 then
      vim.notify("The `forester` command is not available!", vim.log.levels.WARN)
    else
      if args ~= nil then
        command(args)
      else
        command()
      end
    end
  end
end

return M
