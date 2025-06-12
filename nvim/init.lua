local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({"git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", lazypath})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup(require("plugins"))

require("config")

-- vim.cmd([[
-- so ~/.config/nvim/init-orig.vim
-- ]])

local has_words_before = function()
	unpack = unpack or table.unpack
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local feedkey = function(key, mode)
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

-- require("avante").setup()
--
-- vim.opt.laststatus = 3

local cmp = require'cmp'

cmp.setup({
	snippet = {
		expand = function(args) 
			vim.fn["vsnip#anonymous"](args.body)
		end,
	},
	window = {
		-- completion = cmp.config.window.bordered(),
		-- documentation = cmp.config.window.bordered(),
	},
	mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping({
		  i = function(fallback)
			  if cmp.visible() and cmp.get_active_entry() then
				  cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
			  else
				  fallback()
			  end
		  end,
		  s = cmp.mapping.confirm({ select = true }),
		  c = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false }),
	  }),
	  ['<Tab>'] = cmp.mapping(function(fallback)
		  if cmp.visible() then
			  cmp.select_next_item()
		  elseif vim.fn["vsnip#available"](1) == 1 then
			  feedkey("<Plug>(vsnip-expand-or-jump)", "")
		  elseif has_words_before() then
			  cmp.complete()
		  else
			  fallback()
		  end
	  end, { "i", "s" }
	  ),
	  ['<S-Tab>'] = cmp.mapping(function()
		  if cmp.visible() then
			  cmp.select_prev_item()
		  elseif vim.fn["vsnip#jumpable"](-1) == 1 then
			  feedkey("<Plug>(vsnip-jump-prev)", "")
		  end
	  end, { "i", "s" }
	  ),
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
	  { name = 'nvim_lsp_signature_help' },
      { name = 'vsnip' }, -- For vsnip users.
      -- { name = 'luasnip' }, -- For luasnip users.
      -- { name = 'ultisnips' }, -- For ultisnips users.
      -- { name = 'snippy' }, -- For snippy users.
    }, {
      { name = 'buffer' },
    })
})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
	sources = cmp.config.sources({
		{ name = 'git' }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
	}, {
		{ name = 'buffer' },
	})
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = 'buffer' }
	}
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = 'path' }
	}, {
		{ name = 'cmdline' }
	})
})

-- Set up lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities()

local lspconfig = require('lspconfig')

-- lspconfig['jedi_language_server'].setup {
-- 	capabilities = capabilities
-- }
lspconfig['pylsp'].setup {
	capabilities = capabilities,
	settings = {
		pylsp = {
			plugins = {
				rope_autoimport = {
					enabled = true
				}
			}
		}
	}
}

lspconfig['gopls'].setup {
	capabilities = capabilties
}

lspconfig['terraform_lsp'].setup {
	cmd = { "/Users/vladrusu/.bin/terraform-lsp"},
	capabilities = capabilities
}

lspconfig['ts_ls'].setup {
	capabilities = capabilities
}

lspconfig['jsonls'].setup {
	capabilities = capabilities
}

lspconfig['clangd'].setup {
	capabilities = capabilities
}

lspconfig['tailwindcss'].setup {
	capabilities = capabilities
}

lspconfig['prismals'].setup {
	capabilities = capabilities
}

vim.diagnostic.config({
	virtual_text = {
		source = "if_many"
	},
	signs = true,
	underline = true,
	update_in_insert = false,
	severity_sort = true,
	float = {
		show_header = true,
		source = "always",
		focusable = false,
	}
})

vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

require("lint").linters_by_ft = {
	python = { "flake8", "mypy" }
}

vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter", "InsertLeave" }, {
	pattern = "*.py",
	callback = function()
		require("lint").try_lint()
	end,
})

vim.keymap.set('n', '<space>l', function()
	require("lint").try_lint()
end, { desc = "Re-run lint" })


require("conform").setup({
	formatters_by_ft = {
		python = { "black", "isort" },
	},
})

vim.keymap.set('n', '<space>f', function()
	require("conform").format({ async = true })
end, { desc = "Format file" })

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<space>f', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})

local cmp_autopairs = require('nvim-autopairs')
cmp_autopairs.setup({
	check_ts = true,
	enable_check_bracket_line = true,
	ignored_next_char = "[%w%.]",
})
-- cmp.event:on(
-- 	'confirm_done',
-- 	cmp_autopairs.on_confirm_done()
-- )

-- require("noice").setup({
--   lsp = {
--     -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
--     override = {
--       ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
--       ["vim.lsp.util.stylize_markdown"] = true,
--       ["cmp.entry.get_documentation"] = true,
--     },
--   },
--   -- you can enable a preset for easier configuration
--   presets = {
--     bottom_search = true, -- use a classic bottom cmdline for search
--     command_palette = true, -- position the cmdline and popupmenu together
--     long_message_to_split = true, -- long messages will be sent to a split
--     inc_rename = false, -- enables an input dialog for inc-rename.nvim
--     lsp_doc_border = false, -- add a border to hover docs and signature help
--   },
-- })

vim.opt.mouse = ""

require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}

local telescope = require('telescope.builtin')
vim.keymap.set('n', '<C-f>', telescope.find_files, {})
vim.keymap.set('n', '<C-t>', telescope.treesitter, {})

vim.keymap.set('n', '<C-g>', ':LazyGit<CR>')

require'toggleterm'.setup{}

local Terminal = require('toggleterm.terminal').Terminal
local run_terminal = Terminal:new({
	hidden = true,
	direction = 'float',
	on_open = function(term)
		vim.cmd('startinsert!')
	end,
	close_on_exit = false
})

function _run_term_toggle()
	run_terminal:toggle()
end

vim.api.nvim_set_keymap('n', '<C-d>', '<cmd>lua _run_term_toggle()<CR>', {noremap = true, silent = true})

function _G.set_terminal_keymaps()
	local opts = { buffer = 0 }
	vim.keymap.set('t', '<esc>', [[<C-\><C-n><C-w>p]], opts)
end

vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')

local conf = require('telescope.config').values
local function toggle_telescope(harpoon_files)
	local file_paths = {}
	for _, item in ipairs(harpoon_files.items) do
		table.insert(file_paths, item.value)
	end

	require('telescope.pickers').new({}, {
		prompt_title = 'Harpoon',
		finder = require('telescope.finders').new_table({
			results = file_paths,
		}),
		previewer = conf.file_previewer({}),
		sorter = conf.generic_sorter({}),
	}):find()
end

require'nvim-treesitter.configs'.setup {
	textobjects = {
		select = {
			enable = true,
			lookahead = true,
			keymaps = {
				["af"] = "@function.outer",
				["if"] = "@function.inner",
				["ac"] = "@class.outer",
				["ic"] = "@class.inner",
				["aa"] = "@parameter.outer",
				["ia"] = "@parameter.inner",
			},
		},
		swap = {
			enable = true,
			swap_next = {
				["<c-y>"] = "@parameter.inner",
			},
			swap_previous = {
				["<c-l>"] = "@parameter.inner",
			},
		},
	},
	selection_modes = {
		['@parameter.outer'] = 'v',
		['@function.outer'] = 'V',
		['@class.outer'] = '<c-v>',
	}
}

require('mason').setup()
require('mason-lspconfig').setup()

-- Debugger Adapter Protocol
local dap = require('dap')
dap.adapters.python = function(cb, config)
	if config.request == 'attach' then
		local port = (config.connect or config).port
		local host = (config.connect or config).host or '127.0.0.1'
		cb({
			type = 'server',
			port = assert(port, '`connect.port` is required for a python attach configuration'),
			host = host,
			options = {
				source_filetype = 'python',
			}
		})
	else
		cb({
			type = 'executable',
			command = '/Users/vladrusu/.local/share/nvim/mason/packages/debugpy/venv/bin/python',
			args = { '-m', 'debugpy.adapter' },
			options = {
				source_filetype = 'python',
			}
		})
	end
end
dap.configurations.python = {
	{
		type = 'python';
		request = 'launch';
		name = 'Launch file';

		program = "${file}";
		pythonPath = function()
			local cwd = vim.fn.getcwd()
			if vim.fn.executable(cwd .. '/venv/bin/python') == 1 then
				return cwd .. '/venv/bin/python'
			else
				return '/Users/vladrusu/.pyenv/shims/python'
			end
		end;
	},
}

--require("edgy").setup({
--	right = {
--		{
--			ft = "toggleterm",
--			size = { height = 0.4 },
--			filter = function(buf, win)
--				return vim.api.nvim_win_get_config(win).relative == ""
--			end,
--		},
--		"Trouble",
--		{ ft = "qf", title = "QuickFix" },
--	},
--})
--
require("trouble").setup({
	modes = {
		diagnostics_buffer = {
			mode = "diagnostics",
			filter = { buf = 0 }
		}
	}
})

require("yazi").setup({
	keymaps = {
		show_help = "<leader>h",
		grep_in_directory = "<C-/>",
		change_working_directory = "<C-d>",
	}
})

vim.api.nvim_set_keymap('n', '<C-a>', '<cmd>Yazi cwd<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader><leader>', '<cmd>Yazi toggle<CR>', { noremap = true, silent = true })

require('arrow').setup({
	show_icons = false,
	leader_key = ';',
	buffer_leader_key = '<leader>c',
})

vim.api.nvim_set_keymap('n', ']]', 'Treewalker Down<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '[[', 'Treewalker Up<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '{{', 'Treewalker Left<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '}}', 'Treewalker Right<CR>', { noremap = true })

vim.api.nvim_set_keymap('n', '<C-,>', 'GundoToggle<CR>', { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<C-e>', '<C-W>j', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-u>', '<C-W>k', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-n>', '<C-W>h', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-i>', '<C-W>l', { noremap = true })

vim.cmd('colorscheme gruvbox')
