return {
  {
    "caenrique/nvim-maximize-window-toggle",
    keys = { { "<leader>wm", "<cmd>ToggleOnly<cr>", desc = "Max/Min Window" } },
  },
  {
    "goolord/alpha-nvim",
    opts = function()
      local dashboard = require("alpha.themes.dashboard")
      local button_rs = dashboard.button("s", " " .. " Restore Session", [[:lua require("persisted").load() <cr>]])
      button_rs.opts.hl = "AlphaButtons"
      button_rs.opts.hl_shortcut = "AlphaShortcut"
      dashboard.section.buttons.val[6] = button_rs
      local button = dashboard.button("p", " " .. " Projects", ":Telescope projects <CR>")
      button.opts.hl = "AlphaButtons"
      button.opts.hl_shortcut = "AlphaShortcut"
      table.insert(dashboard.section.buttons.val, 4, button)
    end,
  },
  {
    "akinsho/bufferline.nvim",
    opts = {
      options = {
        separator_style = { "slope", "slant" },
      },
    },
  },
}
