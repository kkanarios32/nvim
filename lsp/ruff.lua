return {
  on_attach = function(client)
    client.server_capabilities.hoverProvider = false
  end,
  settings = {
    organizeImports = true,
  },
  filetypes = { "python" },
}
