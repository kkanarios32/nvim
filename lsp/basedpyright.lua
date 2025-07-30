return {
  cmd = { "basedpyright-langserver", "--stdio" },
  settings = {
    basedpyright = {
      disableOrganizeImports = true,
      typeCheckingMode = "basic",
      analysis = {
        autoImportCompletions = true,
        diagnosticMode = "openFilesOnly",
        inlayHints = {
          callArgumentNamesMatching = true,
          genericTypes = true,
        },
      }
    }
  },
  filetypes = { "python" },
  on_attach = function(client, bufnr)
    client.server_capabilities.hoverProvider = true
  end,
}
