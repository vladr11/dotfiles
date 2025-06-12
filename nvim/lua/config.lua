-- General

vim.opt.history = 300

vim.g.mapleader = ","

-- Set to auto read when a file is changed from another place
vim.opt.autoread = true

-- Change the map leader
vim.g.mapleader = ","

-- Reset conceallevel set by indentLine
vim.g.indentLine_conceallevel = 0

-- User Interface
-- Set 7 lines to the cursor - when moving vertically with j/k
vim.opt.scrolloff = 7

-- Line numbers
vim.o.number = true
vim.o.relativenumber = true

-- Relative numbers in normal mode, absolute numbers in insert mode/unfocused
vim.api.nvim_create_augroup('numbertoggle', { clear = true })

vim.api.nvim_create_autocmd({ 'BufEnter', 'FocusGained', 'InsertLeave' }, {
	group = 'numbertoggle',
	pattern = "*",
	callback = function()
		if vim.o.number then
			vim.o.relativenumber = true
		end
	end,
})

vim.api.nvim_create_autocmd({ 'BufLeave', 'FocusLost', 'InsertEnter' }, {
	group = 'numbertoggle',
	pattern = '*',
	callback = function()
		vim.o.relativenumber = false
	end,
})

vim.opt.wildmenu = true
vim.opt.wildignore = { '*.o', '*~', '*.pyc' }

vim.opt.ruler = true

vim.opt.cmdheight = 2

vim.opt.hidden = true

vim.opt.backspace = { 'eol', 'start', 'indent' }

vim.opt.ignorecase = true

vim.opt.smartcase = true

vim.opt.hlsearch = true
vim.opt.incsearch = true

vim.opt.lazyredraw = true

vim.opt.magic = true

vim.opt.showmatch = true

vim.opt.matchtime = 3

vim.opt.errorbells = false
vim.opt.visualbell = false
vim.opt.tm = 500

-- Airline config

vim.g['airline#extensions#tabline#enabled'] = 1
vim.g['airline#extensions#tabline#fnamemod'] = ':t'

-- Colors and Fonts

vim.cmd('syntax enable')

vim.opt.encoding = 'utf8'

-- Use Unix as the standard file type
vim.opt.fileformats = { 'unix', 'dos', 'mac' }

-- Files, backups & undo

vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false

-- Text, tab and indent

vim.opt.smarttab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4

-- Linebreak
vim.opt.linebreak = true
vim.opt.textwidth = 500

vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.wrap = true

-- Visual mode

vim.keymap.set('v', '*', ":call VisualSelection('f')<CR>", { silent = true, noremap = true })
vim.keymap.set('v', '#', ":call VisualSelection('b')<CR>", { silent = true, noremap = true })

-- Moving around

vim.keymap.set('', '<leader><CR>', ":noh<CR>", { silent = true })

vim.opt.splitbelow = true

pcall(function()
	vim.opt.switchbuf = { 'useopen', 'usetab', 'newtab' }
	vim.opt.showtabline = 2
end)

vim.api.nvim_create_autocmd('BufReadPost', {
	pattern = '*',
	callback = function()
		local last_pos = vim.fn.line([['"]])
		if last_pos > 0 and last_pos <= vim.fn.line('$') then
			vim.cmd([[normal! g`"]])
		end
	end,
})

vim.opt.viminfo:append('%')

-- Status Line

vim.opt.laststatus = 2

vim.opt.statusline = [[\ %{HasPaste(}%F%m%r%h\ %w\ \ CWD:\ %r%{getcwd(}%h\ \ \ Line:\ %l]]

vim.keymap.set('', '0', '^')

-- FZF

vim.keymap.set('n', '<C-f>', ":call fzf#run({'sink': 'e', 'down': '20%'})<CR>", { silent = true, noremap = true })
vim.keymap.set('n', '<C-x>', ':Ag<CR>', { silent = true, noremap = true })

-- Folding

vim.keymap.set('', '<leader>z', 'zA', { silent = true, noremap = true })
vim.keymap.set('', 'zz', 'za', { silent = true, noremap = true })

vim.cmd('colorscheme gruvbox')
vim.opt.background = 'dark'

function VisualSelection(direction)
	local saved_reg = vim.fn.getreg('"')

	vim.cmd('normal! vgvy')
	local pattern = vim.fn.escape(vim.fn.getreg('"'), [[\\/.*$^~[]])
	pattern = pattern:gsub('\n$', '')

	if direction == 'b' then
		vim.cmd('normal ?' .. pattern .. '\n')
	elseif direction == 'gv' then
		vim.cmd('vimgrep /' .. pattern .. '/ **/*.')
	elseif direction == 'replace' then
		vim.cmd('%s/' .. pattern .. '/')
	elseif direction == 'f' then
		vim.cmd('normal /' .. pattern .. '\n')
	end

	vim.fn.setreg('/', pattern)
	vim.fn.setreg('"', saved_reg)
end

function HasPaste()
	if vim.o.paste then
		return 'PASTE MODE  '
	end
	return ''
end

vim.keymap.set('n', ']c', '<Plug>GitGutterNextHunk', { silent = true })
vim.keymap.set('n', '[c', '<Plug>GitGutterPrevHunk', { silent = true })
vim.keymap.set('n', '<leader>hs', '<Plug>GitGutterStageHunk', { silent = true })
vim.keymap.set('n', '<leader>hu', '<Plug>GitGutterUnstageHunk', { silent = true })

vim.keymap.set('n', '<C-g>', ':!lazygit<CR><CR>', { noremap = true })

vim.g.EasyMotion_do_mapping = 0
vim.g.EasyMotion_smartcase = 1

vim.keymap.set('n', '<leader>w', '<Plug>(easymotion-bd-w)', { silent = true })
vim.keymap.set('n', '<leader>f', '<Plug>(easymotion-overwin-f)', { silent = true })

vim.g.ackprg = 'ag --nogroup --nocolor --column'

vim.g.airline_powerline_fonts = 1
vim.g.airline_theme = 'zenburn'
