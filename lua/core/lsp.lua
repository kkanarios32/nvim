local on_attach =
    function(event)
      local map = function(keys, func, desc, mode)
        mode = mode or "n"
        vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
      end

      map("gd", require("fzf-lua").lsp_definitions, "[G]oto [D]efinition")
      map("gr", require("fzf-lua").lsp_references, "[G]oto [R]eferences")
      map("gI", require("fzf-lua").lsp_implementations, "[G]oto [I]mplementation")
      map("<leader>D", require("fzf-lua").lsp_typedefs, "Type [D]efinition")
      map("<leader>ds", require("fzf-lua").lsp_document_symbols, "[D]ocument [S]ymbols")
      map(
        "<leader>ws",
        require("fzf-lua").lsp_live_workspace_symbols,
        "[W]orkspace [S]ymbols"
      )
      map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
      map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })
      map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

      -- This function resolves a difference between neovim nightly (version 0.11) and stable (version 0.10)
      ---@param client vim.lsp.Client
      ---@param method vim.lsp.protocol.Method
      ---@param bufnr? integer some lsp support methods only in specific files
      ---@return boolean
      local function client_supports_method(client, method, bufnr)
        if vim.fn.has("nvim-0.11") == 1 then
          return client:supports_method(method, bufnr)
        else
          return client.supports_method(method, { bufnr = bufnr })
        end
      end

      local client = vim.lsp.get_client_by_id(event.data.client_id)
      if client:supports_method('textDocument/completion') then
        -- Optional: trigger autocompletion on EVERY keypress. May be slow!
        -- local chars = {}; for i = 32, 126 do table.insert(chars, string.char(i)) end
        -- client.server_capabilities.completionProvider.triggerCharacters = chars

        vim.lsp.completion.enable(true, client.id, event.buf, { autotrigger = true })
      end
      if
          client
          and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf)
      then
        local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
          buffer = event.buf,
          group = highlight_augroup,
          callback = vim.lsp.buf.document_highlight,
        })

        vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
          buffer = event.buf,
          group = highlight_augroup,
          callback = vim.lsp.buf.clear_references,
        })

        vim.api.nvim_create_autocmd("LspDetach", {
          group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
          callback = function(event2)
            vim.lsp.buf.clear_references()
            vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
          end,
        })
      end

      if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
        map("<leader>th", function()
          vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
        end, "[T]oggle Inlay [H]ints")
      end
    end,
    -- Diagnostic Config
    -- See :help vim.diagnostic.Opts
    vim.diagnostic.config({
      severity_sort = true,
      float = { border = "rounded", source = "if_many" },
      underline = { severity = vim.diagnostic.severity.ERROR },
      signs = vim.g.have_nerd_font and {
        text = {
          [vim.diagnostic.severity.ERROR] = "󰅚 ",
          [vim.diagnostic.severity.WARN] = "󰀪 ",
          [vim.diagnostic.severity.INFO] = "󰋽 ",
          [vim.diagnostic.severity.HINT] = "󰌶 ",
        },
      } or {},
      virtual_text = {
        source = "if_many",
        spacing = 2,
        format = function(diagnostic)
          local diagnostic_message = {
            [vim.diagnostic.severity.ERROR] = diagnostic.message,
            [vim.diagnostic.severity.WARN] = diagnostic.message,
            [vim.diagnostic.severity.INFO] = diagnostic.message,
            [vim.diagnostic.severity.HINT] = diagnostic.message,
          }
          return diagnostic_message[diagnostic.severity]
        end,
      },
    })

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = on_attach,
})

local complete_client = function(arg)
  return vim
      .iter(vim.lsp.get_clients())
      :map(function(client)
        return client.name
      end)
      :filter(function(name)
        return name:sub(1, #arg) == arg
      end)
      :totable()
end
vim.api.nvim_create_user_command('LspRestart', function(info)
  local clients = info.fargs

  -- Default to restarting all active servers
  if #clients == 0 then
    clients = vim
        .iter(vim.lsp.get_clients())
        :map(function(client)
          return client.name
        end)
        :totable()
  end

  for _, name in ipairs(clients) do
    if vim.lsp.config[name] == nil then
      vim.notify(("Invalid server name '%s'"):format(name))
    else
      vim.lsp.enable(name, false)
    end
  end

  local timer = assert(vim.uv.new_timer())
  timer:start(500, 0, function()
    for _, name in ipairs(clients) do
      vim.schedule_wrap(function(x)
        vim.lsp.enable(x)
      end)(name)
    end
  end)
end, {
  desc = 'Restart the given client',
  nargs = '?',
  complete = complete_client,
})


vim.lsp.enable({
  "forester",
  "texlab",
  "clangd",
  "basedpyright",
  "lua_ls",
  "ruff",
})
