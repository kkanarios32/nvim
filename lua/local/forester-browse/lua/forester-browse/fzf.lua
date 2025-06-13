local forester = require("forester-browse.bindings")
local make_entry = require("fzf-lua.make_entry")
local M = {}

local split = function(inputstr, sep)
  if sep == nil then
    sep = "%s"
  end
  local t = {}
  for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
    table.insert(t, str)
  end
  return t
end

-- local pick_config = function(config_files, opts)
--   opts = opts or {}
--
--   pickers
--       .new(opts, {
--         prompt_title = "Pick a config",
--         finder = finders.new_table({
--           results = config_files,
--           --entry_maker = entry_maker,
--         }),
--         previewer = previewers.vim_buffer_cat.new(opts),
--         sorter = conf.generic_sorter(opts),
--         attach_mappings = function(prompt_bufnr, map)
--           actions.select_default:replace(function()
--             actions.close(prompt_bufnr)
--             local selection = action_state.get_selected_entry()
--             vim.g.forester_current_config = config.parse(selection[1])
--           end)
--           return true
--         end,
--       })
--       :find()
-- end

M.pick_by_title = function(opts)
  if not opts then
    opts = { fzf_opts = {} }
    opts.actions = {
      ["default"] = function(selected)
        local parts = split(selected[1], ",")
        vim.cmd("edit " .. parts[2])
      end,
    }
  end
  require("fzf-lua").fzf_exec(function(fzf_cb)
    local config = vim.g.forester_current_config
    for _, tree in pairs(forester.query_all(config.path)) do
      local entry
      if tree.title ~= "" then
        do
          entry = string.format("%s,%s", tree.title, tree.sourcePath)
        end
      end
      if entry then
        fzf_cb(entry, function(err)
          if err then
            return
          end
          fzf_cb(nil)
        end)
      end
    end
    fzf_cb()
  end, opts)
end

M.pick_by_title()

return M
