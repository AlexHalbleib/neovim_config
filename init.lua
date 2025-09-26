-- install mini pack
-- Put this at the top of 'init.lua'
local path_package = vim.fn.stdpath('data') .. '/site'
local mini_path = path_package .. '/pack/deps/start/mini.pick'
if not vim.loop.fs_stat(mini_path) then
	vim.cmd('echo "Installing `mini.pick`" | redraw')
	local clone_cmd = {
		'git', 'clone', '--filter=blob:none',
		-- Uncomment next line to use 'stable' branch
		'--branch', 'stable',
		'https://github.com/nvim-mini/mini.pick', mini_path
	}
	vim.fn.system(clone_cmd)
	vim.cmd('packadd mini.nvim | helptags ALL')
	vim.cmd('echo "Installed `mini.nvim`" | redraw')
end

-- basic option settings
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.wrap = false
vim.opt.smartindent = true
vim.opt.winborder = 'rounded'
vim.opt.signcolumn = "yes"

vim.g.mapleader = " "

-- keymappings 
vim.keymap.set('n', '<leader>w', ':write<cr>')
vim.keymap.set('n', '<leader>s', ':write<cr> :so<cr>')
vim.keymap.set('n', '<leader>m', ':Mason<cr>')
vim.keymap.set('n', '<leader>q', ':quit<cr>')
vim.keymap.set('n', '<leader>lf', vim.lsp.buf.format)
vim.keymap.set('n', '<leader>k', vim.lsp.buf.definition)

-- lsp stuff
-- my mason installs ruff and basedpyright
require('mason').setup()


vim.api.nvim_create_autocmd('LspAttach', {
	group = vim.api.nvim_create_augroup('my.lsp', {}),
	callback = function(args)
		local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
		if client:supports_method('textDocument/completion') then
			-- Optional: trigger autocompletion on EVERY keypress. May be slow!
			local chars = {}; for i = 32, 126 do table.insert(chars, string.char(i)) end
			client.server_capabilities.completionProvider.triggerCharacters = chars
			vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
		end
	end,
})

vim.lsp.enable({
	'lua_ls',
	'ruff',
	'basedpyright'
})

vim.cmd("set completeopt+=noselect,menuone,popup")
