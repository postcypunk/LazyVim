return {
  -- {
  --   "folke/which-key.nvim",
  --   opts = function()
  --     require("which-key").register({
  --       ["<leader>f"] = { name = "󰍉 Find" },
  --       ["<leader>c"] = { name = " Coding" },
  --       ["<leader>u"] = { name = " UI" },
  --       ["<leader>b"] = { name = "󰓩 Buffers" },
  --       ["<leader>d"] = { name = " Debugger" },
  --       ["<leader>g"] = { name = "󰊢 Git" },
  --       ["<leader>q"] = { name = "󱂬 Session" },
  --       ["<leader>t"] = { name = " Terminal" },
  --     })
  --   end,
  -- },
  {
    "caenrique/nvim-maximize-window-toggle",
    keys = { { "<leader>wm", "<cmd>ToggleOnly<cr>", desc = "Max/Min Window" } },
  },
  {
    "akinsho/bufferline.nvim",
    keys = {
      { "<leader>b,", "<cmd>BufferLineMovePrev<cr>", desc = "Move BufferLeft" },
      { "<leader>b.", "<cmd>BufferLineMoveNext<cr>", desc = "Move BufferRight" },
      { "<leader>bg", "<cmd>BufferLinePick<cr>", desc = "Pick Buffer Visually" },
    },
    opts = {
      options = {
        separator_style = "slant",
        diagnostics = "nvim_lsp",
        diagnostics_update_in_insert = false,
        diagnostics_indicator = function(count, level, diagnostics_dict, context)
          local s = " "
          for e, n in pairs(diagnostics_dict) do
            if e == "error" then
              local sym = e == "error" and " " or (e == "warning" and " " or "i")
              s = s .. n .. sym
            end
          end
          return s
        end,
      },
    },
    config = true,
  },
  -- windwo picker
  {
    "s1n7ax/nvim-window-picker",
    version = "v1.*",
    keys = {
      {
        "<leader>wP",
        function()
          local current_buf = vim.api.nvim_get_current_buf()
          local picked_window_id = require("window-picker").pick_window() or vim.api.nvim_get_current_win()
          vim.api.nvim_win_close(vim.api.nvim_get_current_win(), true)
          vim.api.nvim_set_current_win(picked_window_id)
          vim.api.nvim_win_set_buf(picked_window_id, current_buf)
        end,
        "n",
        desc = "Replace a window",
      },
      {
        "<leader>wp",
        function()
          local picked_window_id = require("window-picker").pick_window() or vim.api.nvim_get_current_win()
          vim.api.nvim_set_current_win(picked_window_id)
        end,
        "n",
        desc = "Pick a window",
      },
    },

    config = function()
      require("window-picker").setup({
        use_winbar = "smart",
        other_win_hl_color = "#B4BEFE",
        autoselect_one = true,
        include_current = false,
        filter_rules = {
          -- filter using buffer options
          bo = {
            -- if the file type is one of following, the window will be ignored
            filetype = { "neo-tree", "neo-tree-popup", "notify" },

            -- if the buffer type is one of following, the window will be ignored
            buftype = { "terminal", "quickfix" },
          },
        },
        -- include_current_win = true,
        -- selection_display = function(char)
        --   return ":::" .. char
        -- end,
      })
    end,
  },
  --win sep
  {
    "nvim-zh/colorful-winsep.nvim",
    config = true,
    event = { "WinNew" },
  },
  --focus---
  {
    "beauwilliams/focus.nvim",
    keys = { { "<leader>wa", "<cmd>FocusToggle<cr>", desc = "Focus Split Nicely" } },
    cmd = { "FocusToggle", "FocusSplitCycle", "FocusSplitNicely" },
    module = "focus",
    config = function(_, opts)
      local focus = require("focus")
      focus.setup(opts)
      focus.focus_disable()
    end,
  },
  ---------------------remove indentscope animation-----------

  {
    "echasnovski/mini.indentscope",
    enabled = false,
    config = function(_, opts)
      -- require("mini.indentscope").gen_animation.none()
      -- require("mini.indentscope").setup(opts)
    end,
  },

  --- hl chunk
  {
    "shellRaining/hlchunk.nvim",
    keys = {
      { "<leader>uuH", "<cmd>EnableHL<CR>", { desc = "EnableHL" } },
      { "<leader>uuh", "<cmd>DisableHL<CR>", { desc = "DisableHL" } },
    },
    event = { "UIEnter" },
    config = function(_, opts)
      require("hlchunk").setup(opts)
    end,
  },
  { "lukas-reineke/indent-blankline.nvim", enabled = false },
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      local mocha = require("catppuccin.palettes").get_palette("mocha")
      opts.sections.lualine_c[3].color = { fg = mocha.mauve }
      opts.sections.lualine_x[3].color = { bg = mocha.red }
      -- opts.sections.lualine_c[4] = {
      --   function()
      --     return require("noice").api.status.message.get()
      --   end,
      --   cond = require("noice").api.status.message.has,
      -- }
      table.insert(opts.sections.lualine_b, 2, {
        "diff",
        symbols = { added = " ", modified = " ", removed = " " },
        diff_color = {
          added = { fg = mocha.green },
          modified = { fg = mocha.peach },
          removed = { fg = mocha.red },
          -- TODO
        },
      })
      table.insert(opts.sections.lualine_c, 1, {
        -- Lsp server name .
        function()
          local msg = "No LSP"
          local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
          local clients = vim.lsp.get_active_clients()
          if next(clients) == nil then
            return msg
          end
          for _, client in ipairs(clients) do
            local filetypes = client.config.filetypes
            if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
              return client.name
            end
          end
          return msg
        end,
        icon = ":",
        color = { fg = mocha.green },
      })

      opts.sections.lualine_x[5] = { "encoding", color = { fg = mocha.peach } }
      opts.sections.lualine_x[6] = { "filesize", color = { fg = mocha.green } }
    end,
  },
  {
    "HiPhish/nvim-ts-rainbow2",
    config = function()
      require("nvim-treesitter.configs").setup({
        rainbow = {
          enable = true,
          -- list of languages you want to disable the plugin for
          disable = { "jsx", "cpp" },
          -- Which query to use for finding delimiters
          query = "rainbow-parens",
          -- Highlight the entire buffer all at once
          strategy = require("ts-rainbow").strategy.global,
        },
      })
    end,
  },
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    cmd = { "ToggleTerm", "TermExec" },
    keys = {
      { "<leader>th", "<cmd>ToggleTerm size=15 direction=horizontal name=ht<cr>", desc = "Toggleterm Horizontal" },
      { "<leader>tv", "<cmd>ToggleTerm direction=vertical name=vt<cr>", desc = "Toggleterm Horizontal" },
      { "<leader>tt", "<cmd>ToggleTerm direction=float name=ft<cr>", desc = "Toggleterm Floating" },
      { "<leader>tcc", "<cmd>ToggleTermSendCurrentLine<cr>", desc = "Term exec Current Line" },
      {
        "<leader>tcy",
        function()
          require("toggleterm").exec(vim.fn.getreg("+"))
        end,
        desc = "Term exec clipboard",
      },
      { "<leader>tcc", "<cmd>ToggleTermSendVisualSelection<cr>", mode = { "x" }, desc = "Term exec Current Selection" },
    },
    opts = {
      size = function(term)
        if term.direction == "horizontal" then
          return 10
        elseif term.direction == "vertical" then
          return vim.o.columns * 0.4
        else
          return 20
        end
      end,
      on_create = function()
        vim.opt.foldcolumn = "0"
        vim.opt.signcolumn = "no"
      end,
      -- shell="fish",
      open_mapping = [[<F7>]],
      shading_factor = 2,
      direction = "horizontal",
      float_opts = {
        border = "curved",
        highlights = { border = "Normal", background = "Normal" },
      },
    },
  },
  {
    "utilyre/barbecue.nvim",
    name = "barbecue",
    version = "*",
    dependencies = {
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons", -- optional dependency
    },
    opts = {
      theme = "catppuccin",
    },
    config = true,
    -- config = function()
    --   require("barbecue").setup({
    --     theme = "catppuccin",
    --   })
    -- end,
  },
  -- {
  --   "xiyaowong/transparent.nvim",
  --   opts = {
  --     extra_groups = {
  --       "NotifyBackground",
  --     },
  --   },
  --   config = function()
  --     vim.api.nvim_set_hl(0, "NotifyBackground", vim.api.nvim_get_hl_by_name("Normal", true))
  --     vim.g.transparent_groups = vim.list_extend(
  --       vim.g.transparent_groups or {},
  --       vim.tbl_map(function(v)
  --         return v.hl_group
  --       end, vim.tbl_values(require("bufferline.config").highlights))
  --     )
  --   end,
  -- },
  {
    "folke/noice.nvim",
    opts = function(_, opts)
      table.insert(opts.routes, {
        filter = {
          event = "msg_show",
          any = {
            { find = "Pick window:" },
            { find = "AutoSave" },
          },
        },
        opts = { skip = true },
      })
      table.insert(opts.routes, {
        filter = {
          event = "notify",
          find = "hlchunk",
        },
        opts = { skip = true },
      })
    end,
  },
  {
    "rcarriga/nvim-notify",
    opts = function(_, opts)
      opts.timeout = 1000
      opts.stages = "static"
    end,
  },
  {
    "anuvyklack/hydra.nvim",
    dependencies = {
      "mrjones2014/smart-splits.nvim",
      "sindrets/winshift.nvim",
    },
    config = function()
      local Hydra = require("hydra")
      local splits = require("smart-splits")

      local cmd = require("hydra.keymap-util").cmd
      local pcmd = require("hydra.keymap-util").pcmd
      local window_hint = [[
                  Size            Move               Split
             -------------    -----------       ---------------
      k            K             <C-k>         s : horizontally 
  h       l    H       L     <C-h>   <C-l>     v : vertically
      j            J             <C-j>         q : close
 focus        window          = : equalize                 
                                                              
]]
      Hydra({
        name = "Windows",
        hint = "window mdoe",
        -- hint = window_hint,
        config = {
          invoke_on_body = true,
          -- hint = false,
          hint = {
            border = "rounded",
            offset = -1,
            show_name = false,
          },
        },
        mode = "n",
        body = "<leader>w;",
        heads = {
          { "h", "<C-w>h" },
          { "j", "<C-w>j" },
          { "k", pcmd("wincmd k", "E11", "close") },
          { "l", "<C-w>l" },

          { "<c-h>", cmd("WinShift left") },
          { "<c-j>", cmd("WinShift down") },
          { "<c-k>", cmd("WinShift up") },
          { "<c-l>", cmd("WinShift right") },

          {
            "H",
            function()
              splits.resize_left(2)
            end,
          },
          {
            "J",
            function()
              splits.resize_down(2)
            end,
          },
          {
            "K",
            function()
              splits.resize_up(2)
            end,
          },
          {
            "L",
            function()
              splits.resize_right(2)
            end,
          },
          { "=", "<C-w>=", { desc = "equalize" } },

          { "s", pcmd("split", "E36") },
          { "v", pcmd("vsplit", "E36") },

          { "q", pcmd("close", "E444"), { desc = "close window" } },
          { "<C-c>", pcmd("close", "E444"), { desc = false } },
          { "<C-q>", pcmd("close", "E444"), { desc = false } },

          { "<Esc>", nil, { exit = true, desc = false } },
        },
      })
    end,
  },
}
