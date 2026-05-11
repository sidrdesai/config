return {
  {
    "sainnhe/everforest",
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.everforest_background = "hard"
      vim.g.everforest_better_performance = 1
      vim.g.everforest_enable_italic = 1
      --vim.cmd.colorscheme("everforest")
    end,
  },
  {
    "rose-pine/neovim",
    name = "rose-pine",
    config = function()
      require("rose-pine").setup({
        dark_variant = "moon",
        disable_background = false,
      })
      vim.cmd.colorscheme("rose-pine")
    end,
  },
  -- sync terminal background color with colorscheme
  {
    "typicode/bg.nvim",
  },
  -- change trouble config
  {
    "folke/trouble.nvim",
    opts = { use_diagnostic_signs = true },
  },
  -- add more treesitter parsers
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "bash",
        "html",
        "javascript",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "typescript",
        "css",
        "yaml",
      })
    end,
  },
}
