return {
  {
    "rrethy/vim-hexokinase",
    build = "make hexokinase",
    event = "BufReadPre",
    config = function()
      vim.g.Hexokinase_highlighters = { "virtual" }
      vim.g.Hexokinase_virtualText = "■"
    end,
  },
  {
    "esmuellert/nvim-eslint",
    config = function()
      require("nvim-eslint").setup({})
    end,
  },
}
