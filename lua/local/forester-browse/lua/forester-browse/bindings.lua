---@tag forester.bindings

---@brief [[
---
--- Bindings to the forester program.
---
---]]

local Job = require("plenary.job")

local bindings = {}

---@param arg string
---@param config string
---@return table|nil
local function query(arg, config)
  local res = Job:new({
    command = "forester",
    args = { "query", arg, config },
  }):sync()
  return res
end

---@param config string
---@return table | nil
local function query_all(config)
  local res = Job:new({
    command = "forester",
    -- args = { "query", "all", config },
    args = { "query", "all" },
  }):sync()
  if res ~= nil then
    return vim.json.decode(res[1])
  end
end

bindings.query = query
bindings.query_all = query_all

return bindings
