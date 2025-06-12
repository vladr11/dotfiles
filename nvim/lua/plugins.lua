require("lazy").setup({
  -- Core Dependencies
  { "nvim-lua/plenary.nvim" },

  -- UI Enhancements
  { "vim-airline/vim-airline" },
  { "vim-airline/vim-airline-themes" },
  { "ellisonleao/gruvbox.nvim" },
  { "MunifTanjim/nui.nvim" },
  { "folke/noice.nvim", dependencies = { "rcarriga/nvim-notify" } },
  { "rcarriga/nvim-notify" },
  { "folke/edgy.nvim" },

  -- Git Integration
  { "airblade/vim-gitgutter" },
  { "tpope/vim-fugitive" },
  { "sindrets/diffview.nvim" },
  { "kdheepak/lazygit.nvim" },

  -- LSP and Auto-completion
  { "neovim/nvim-lspconfig" },
  { "mfussenegger/nvim-lint" },
  { "stevearc/conform.nvim" },
  { "williamboman/mason.nvim" },
  { "williamboman/mason-lspconfig.nvim" },
  { "stevearc/dressing.nvim" },
  { "hrsh7th/nvim-cmp", dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-vsnip",
      "hrsh7th/vim-vsnip",
      "hrsh7th/cmp-nvim-lsp-signature-help",
      "rafamadriz/friendly-snippets"
    }
  },
  {
	  "yetone/avante.nvim",
	  event = "VeryLazy",
	  version = "*",
	  opts = {
		  provider = "claude",
		  claude = {
			  endpoint = "https://api.anthropic.com",
			  model = "claude-3-5-sonnet-20241022",
			  temperature = 0,
			  max_tokens = 4096,
		  },
	  },
	  build = "make",
	  dependencies = {
		  "stevearc/dressing.nvim",
		  "nvim-lua/plenary.nvim",
		  "echasnovski/mini.pick",
	  },
	  {
		  'MeanderingProgrammer/render-markdown.nvim',
		  opts = {
			  file_types = { "markdown", "Avante" },
		  },
		  fd = { "markdown", "Avante" },
	  }
  },

  -- Syntax Highlighting and Treesitter
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
  { "nvim-treesitter/nvim-treesitter-textobjects" },
  { "aaronik/treewalker.nvim" },

  -- File Navigation & Search
  { "junegunn/fzf", build = "./install --bin" },
  { "junegunn/fzf.vim" },
  { "nvim-telescope/telescope.nvim" },
  { "ibhagwan/fzf-lua" },

  -- Editor Enhancements
  { "windwp/nvim-autopairs", config = function() require("nvim-autopairs").setup() end },
  { "editorconfig/editorconfig-vim" },
  { "Yggdroot/indentLine" },
  { "tpope/vim-surround" },
  { "easymotion/vim-easymotion" },
  { "otavioschwanck/arrow.nvim" },

  -- DAP (Debugging)
  { "mfussenegger/nvim-dap" },
  { "puremourning/vimspector" },

  -- Programming Language Support
  { "cespare/vim-toml" },
  { "leafgarland/typescript-vim" },
  { "pangloss/vim-javascript" },
  { "prisma/vim-prisma" },
  { "mikavilpas/yazi.nvim" },
  { "hashivim/vim-terraform" },
  { "fatih/vim-go", build = ":GoUpdateBinaries" },
  { "uarun/vim-protobuf" },
  { "vim-scripts/indentpython.vim" },

  -- Database & Productivity
  { "tpope/vim-dadbod" },
  { "kristijanhusak/vim-dadbod-ui" },
  { "sjl/gundo.vim" },
  { "mileszs/ack.vim" },
  { "folke/trouble.nvim" },
  { "akinsho/toggleterm.nvim" },
})
