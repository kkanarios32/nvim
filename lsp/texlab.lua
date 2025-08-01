local latex_args = {
  '--synctex-editor-command',
  [[nvim-texlabconfig -file '%%%{input}' -line %%%{line} -server ]] .. vim.v.servername,
  '--synctex-forward',
  '%l:1:%f',
  '%p',
}

local function client_with_fn(fn)
  return function()
    local bufnr = vim.api.nvim_get_current_buf()
    local client = vim.lsp.get_clients({ bufnr = bufnr, name = 'texlab' })[1]
    if not client then
      return vim.notify(('texlab client not found in bufnr %d'):format(bufnr), vim.log.levels.ERROR)
    end
    fn(client, bufnr)
  end
end

local function buf_build(client, bufnr)
  local win = vim.api.nvim_get_current_win()
  local params = vim.lsp.util.make_position_params(win, client.offset_encoding)
  client:request('textDocument/build', params, function(err, result)
    if err then
      error(tostring(err))
    end
    local texlab_build_status = {
      [0] = 'Success',
      [1] = 'Error',
      [2] = 'Failure',
      [3] = 'Cancelled',
    }
    vim.notify('Build ' .. texlab_build_status[result.status], vim.log.levels.INFO)
  end, bufnr)
end

local function buf_search(client, bufnr)
  local win = vim.api.nvim_get_current_win()
  local params = vim.lsp.util.make_position_params(win, client.offset_encoding)
  client:request('textDocument/forwardSearch', params, function(err, result)
    if err then
      error(tostring(err))
    end
    local texlab_forward_status = {
      [0] = 'Success',
      [1] = 'Error',
      [2] = 'Failure',
      [3] = 'Unconfigured',
    }
    vim.notify('Search ' .. texlab_forward_status[result.status], vim.log.levels.INFO)
  end, bufnr)
end

local function buf_cancel_build(client, bufnr)
  if vim.fn.has 'nvim-0.11' == 1 then
    return client:exec_cmd({
      title = 'cancel',
      command = 'texlab.cancelBuild',
    }, { bufnr = bufnr })
  end
  vim.lsp.buf.execute_command { command = 'texlab.cancelBuild' }
  vim.notify('Build cancelled', vim.log.levels.INFO)
end

local function dependency_graph(client)
  client:request('workspace/executeCommand', { command = 'texlab.showDependencyGraph' }, function(err, result)
    if err then
      return vim.notify(err.code .. ': ' .. err.message, vim.log.levels.ERROR)
    end
    vim.notify('The dependency graph has been generated:\n' .. result, vim.log.levels.INFO)
  end, 0)
end

local function command_factory(cmd)
  local cmd_tbl = {
    Auxiliary = 'texlab.cleanAuxiliary',
    Artifacts = 'texlab.cleanArtifacts',
    CancelBuild = 'texlab.cancelBuild',
  }
  return function(client, bufnr)
    if vim.fn.has 'nvim-0.11' == 1 then
      return client:exec_cmd({
        title = ('clean_%s'):format(cmd),
        command = cmd_tbl[cmd],
        arguments = { { uri = vim.uri_from_bufnr(bufnr) } },
      }, { bufnr = bufnr }, function(err, _)
        if err then
          vim.notify(('Failed to clean %s files: %s'):format(cmd, err.message), vim.log.levels.ERROR)
        else
          vim.notify(('command %s executed successfully'):format(cmd), vim.log.levels.INFO)
        end
      end)
    end

    vim.lsp.buf.execute_command {
      command = cmd_tbl[cmd],
      arguments = { { uri = vim.uri_from_bufnr(bufnr) } },
    }
    vim.notify(('command %s executed successfully'):format(cmd_tbl[cmd]))
  end
end

local function buf_find_envs(client, bufnr)
  local win = vim.api.nvim_get_current_win()
  client:request('workspace/executeCommand', {
    command = 'texlab.findEnvironments',
    arguments = { vim.lsp.util.make_position_params(win, client.offset_encoding) },
  }, function(err, result)
    if err then
      return vim.notify(err.code .. ': ' .. err.message, vim.log.levels.ERROR)
    end
    local env_names = {}
    local max_length = 1
    for _, env in ipairs(result) do
      table.insert(env_names, env.name.text)
      max_length = math.max(max_length, string.len(env.name.text))
    end
    for i, name in ipairs(env_names) do
      env_names[i] = string.rep(' ', i - 1) .. name
    end
    vim.lsp.util.open_floating_preview(env_names, '', {
      height = #env_names,
      width = math.max((max_length + #env_names - 1), (string.len 'Environments')),
      focusable = false,
      focus = false,
      border = 'single',
      title = 'Environments',
    })
  end, bufnr)
end

local function buf_change_env(client, bufnr)
  local new = vim.fn.input 'Enter the new environment name: '
  if not new or new == '' then
    return vim.notify('No environment name provided', vim.log.levels.WARN)
  end
  local pos = vim.api.nvim_win_get_cursor(0)
  if vim.fn.has 'nvim-0.11' == 1 then
    return client:exec_cmd({
      title = 'change_environment',
      command = 'texlab.changeEnvironment',
      arguments = {
        {
          textDocument = { uri = vim.uri_from_bufnr(bufnr) },
          position = { line = pos[1] - 1, character = pos[2] },
          newName = tostring(new),
        },
      },
    }, { bufnr = bufnr })
  end

  vim.lsp.buf.execute_command {
    command = 'texlab.changeEnvironment',
    arguments = {
      {
        textDocument = { uri = vim.uri_from_bufnr(bufnr) },
        position = { line = pos[1] - 1, character = pos[2] },
        newName = tostring(new),
      },
    },
  }
end

return {
  cmd = { "texlab" },
  filetypes = { "plaintex", "tex", "bib" },
  root_markers = { '.git', '.latexmkrc', 'latexmkrc', '.texlabroot', 'texlabroot', 'Tectonic.toml' },
  settings = {
    texlab = {
      auxDirectory = ".",
      bibtexFormatter = "texlab",
      build = {
        executable = "latexmk",
        args = { "-pdf", "--shell-escape", "-lualatex", "-g", "-interaction=nonstopmode", "-synctex=1", "%f" },
        forwardSearchAfter = true,
        onSave = true,
      },
      chktex = {
        onEdit = true,
        onOpenAndSave = true,
      },
      diagnosticsDelay = 300,
      formatterLineLength = 80,
      forwardSearch = {
        executable = "zathura",
        args = latex_args,
        onSave = true,
      },
      latexFormatter = "latexindent",
      latexindent = {
        modifyLineBreaks = true,
      },
    },
  },
  on_attach = function()
    vim.api.nvim_buf_create_user_command(0, 'TexlabBuild', client_with_fn(buf_build), {
      desc = 'Build the current buffer',
    })
    vim.api.nvim_buf_create_user_command(0, 'TexlabForward', client_with_fn(buf_search), {
      desc = 'Forward search from current position',
    })
    vim.api.nvim_buf_create_user_command(0, 'TexlabCancelBuild', client_with_fn(buf_cancel_build), {
      desc = 'Cancel the current build',
    })
    vim.api.nvim_buf_create_user_command(0, 'TexlabDependencyGraph', client_with_fn(dependency_graph), {
      desc = 'Show the dependency graph',
    })
    vim.api.nvim_buf_create_user_command(0, 'TexlabCleanArtifacts', client_with_fn(command_factory('Artifacts')), {
      desc = 'Clean the artifacts',
    })
    vim.api.nvim_buf_create_user_command(0, 'TexlabCleanAuxiliary', client_with_fn(command_factory('Auxiliary')), {
      desc = 'Clean the auxiliary files',
    })
    vim.api.nvim_buf_create_user_command(0, 'TexlabFindEnvironments', client_with_fn(buf_find_envs), {
      desc = 'Find the environments at current position',
    })
    vim.api.nvim_buf_create_user_command(0, 'TexlabChangeEnvironment', client_with_fn(buf_change_env), {
      desc = 'Change the environment at current position',
    })
  end,
}
