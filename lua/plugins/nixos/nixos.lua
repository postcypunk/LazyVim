if vim.g.isnix then
  return {
    { "nvim-treesitter/nvim-treesitter", opts = { ensure_installed = {} } },
    { "williamboman/mason-lspconfig.nvim", enabled = false },
    { "williamboman/mason.nvim", enabled = false },
  }
end
