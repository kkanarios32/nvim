return {
  cmd = {
    "clangd-18",
    "--background-index",
    "--suggest-missing-includes",
    "--clang-tidy",
    "--header-insertion=iwyu",
  },
  filetype = { "c", "cpp", "h" }
}
