-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local function map(mode, lhs, rhs, opts)
  local keys = require("lazy.core.handler").handlers.keys
  ---@cast keys LazyKeysHandler
  -- do not create the keymap if a lazy keys handler exists
  if not keys.active[keys.parse({ lhs, mode = mode }).id] then
    opts = opts or {}
    opts.silent = opts.silent ~= false
    vim.keymap.set(mode, lhs, rhs, opts)
  end
end

vim.keymap.set("i", "jj", "<ESC>")

vim.keymap.set("n", "<leader>ws", "<C-w>s", { desc = "split down" })
vim.keymap.set("n", "<leader>wv", "<C-w>v", { desc = "split right" })

map("n", "<c-j>", "<c-w>j")
map("n", "<c-k>", "<c-w>k")

map("n", "<leader><C-v>", '"+p', { desc = "Paste(system)" })
map("v", "<leader>gc", '"+y', { desc = "Copy(system)" })
map("n", "<leader>fm", "gg=G''", { desc = "Format this File" })
map("n", "<leader>uN", "<cmd>Notifications<cr>", { desc = "Show All Notifications" })
map("n", "<leader><leader>", "")
--window pick

vim.keymap.set("n", "<leader>wp", function()
  local picked_window_id = require("window-picker").pick_window() or vim.api.nvim_get_current_win()
  vim.api.nvim_set_current_win(picked_window_id)
end, { desc = "Pick a window" })

--search bidirectional
vim.keymap.set("n", "<leader><leader>s", function()
  local current_window = vim.fn.win_getid()
  require("leap").leap({ target_windows = { current_window } })
end)

--ufo folding
map("n", "zp", function()
  local winid = require("ufo").peekFoldedLinesUnderCursor()
  if not winid then
    -- vim.fn.CocActionAsync("definitionHover") -- coc.nvim
    vim.lsp.buf.hover()
  end
end, { desc = "Peek inside fold" })
-----------color picker------------
map("n", "<leader>cp", "<cmd>PickColor<cr>", { noremap = true, silent = true })
