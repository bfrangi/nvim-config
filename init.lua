-- Install packer
local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
local is_bootstrap = false
local vim = vim
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
	is_bootstrap = true
	vim.fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
	vim.cmd([[packadd packer.nvim]])
end

require("packer").startup(function(use)
	-- Package manager
	use("wbthomason/packer.nvim")

	use({ -- LSP Configuration & Plugins
		"neovim/nvim-lspconfig",
		requires = {
			-- Automatically install LSPs to stdpath for neovim
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",

			-- Useful status updates for LSP
			"j-hui/fidget.nvim",

			-- Additional lua configuration, makes nvim stuff amazing
			"folke/neodev.nvim",
		},
	})

	-- A completion plugin for neovim coded in Lua.
	use({
		"hrsh7th/nvim-cmp",
		requires = {
			-- nvim-cmp source for neovim builtin LSP client
			"hrsh7th/cmp-nvim-lsp",
			-- nvim-cmp source for nvim lua
			"hrsh7th/cmp-nvim-lua",
			-- nvim-cmp source for buffer words
			"hrsh7th/cmp-buffer",
			-- nvim-cmp source for filesystem paths
			"hrsh7th/cmp-path",
			-- nvim-cmp source for math calculation
			"hrsh7th/cmp-calc",

			"L3MON4D3/LuaSnip",
			-- LuaSnip completion source for nvim-cmp
			"saadparwaiz1/cmp_luasnip",
		},
		-- config = [[ require('plugins.cmp') ]]
	})

	-- Snippet Engine for Neovim written in Lua.
	use({
		"L3MON4D3/LuaSnip",
		requires = {
			-- Snippets collection for a set of different programming languages for faster development
			"rafamadriz/friendly-snippets",
		},
		-- config = [[ require('plugins.luasnip') ]]
	})

	use({ -- Highlight, edit, and navigate code
		"nvim-treesitter/nvim-treesitter",
		run = function()
			pcall(require("nvim-treesitter.install").update({ with_sync = true }))
		end,
	})

	use({ -- Additional text objects via treesitter
		"nvim-treesitter/nvim-treesitter-textobjects",
		after = "nvim-treesitter",
	})

	-- Git related plugins
	use("tpope/vim-fugitive")
	use("tpope/vim-rhubarb")
	use("lewis6991/gitsigns.nvim")

  -- Theme
	-- use("navarasu/onedark.nvim") -- Theme inspired by Atom
	use("ellisonleao/gruvbox.nvim")

  use("nvim-lualine/lualine.nvim") -- Fancier statusline
	use("lukas-reineke/indent-blankline.nvim") -- Add indentation guides even on blank lines
	use("numToStr/Comment.nvim") -- "gc" to comment visual regions/lines
	use("tpope/vim-sleuth") -- Detect tabstop and shiftwidth automatically

	-- Harpoon. Navigation|terminal/file switching.
	use("nvim-lua/plenary.nvim")
	use("ThePrimeagen/harpoon")
	use("mbbill/undotree")
	use("ThePrimeagen/vim-be-good")

	-- DoGe. docstring generation
	use({
		"kkoomen/vim-doge",
		run = ":call doge#install()",
	})

	-- markdown preview in browser.
	use({
		"iamcco/markdown-preview.nvim",
		run = function()
			vim.fn["mkdp#util#install"]()
		end,
	})

	-- Auto close parentheses and repeat by dot dot dot ...
	use({
		"windwp/nvim-autopairs",
		config = function()
			require("nvim-autopairs").setup({})
		end,
	})

	-- ale linter
	use({
		"dense-analysis/ale",
		-- config = vim.cmd([[
		--         runtime 'lua/plugins/ale.rc.vim'
		--         ]])
	})

	-- highlight your todo comments in different styles
	use({
		"folke/todo-comments.nvim",
		requires = "nvim-lua/plenary.nvim",
		config = function()
			require("todo-comments").setup({
				-- configuration comes here
				-- or leave it empty to use the default setting
			})
		end,
	})

	use("xiyaowong/nvim-transparent")
	-- Fuzzy Finder (files, lsp, etc)
	use({ "nvim-telescope/telescope.nvim", branch = "0.1.x", requires = { "nvim-lua/plenary.nvim" } })

	-- Fuzzy Finder Algorithm which requires local dependencies to be built. Only load if `make` is available
	use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make", cond = vim.fn.executable("make") == 1 })

  -- Beacon plugin
  use({"danilamihailov/beacon.nvim"})

  -- Plugin to move bits of code
  use ({"matze/vim-move"})

  -- Add custom plugins to packer from ~/.config/nvim/lua/custom/plugins.lua
	local has_plugins, plugins = pcall(require, "custom.plugins")
	if has_plugins then
		plugins(use)
	end

	if is_bootstrap then
		require("packer").sync()
	end
end)

-- When we are bootstrapping a configuration, it doesn't
-- make sense to execute the rest of the init.lua.
--
-- You'll need to restart nvim, and then it will work.
if is_bootstrap then
	print("==================================")
	print("    Plugins are being installed")
	print("    Wait until Packer completes,")
	print("       then restart nvim")
	print("==================================")
	return
end

-- Automatically source and re-compile packer whenever you save this init.lua
local packer_group = vim.api.nvim_create_augroup("Packer", { clear = true })
vim.api.nvim_create_autocmd("BufWritePost", {
	command = "source <afile> | silent! LspStop | silent! LspStart | PackerCompile",
	group = packer_group,
	pattern = vim.fn.expand("$MYVIMRC"),
})

-- [[ Custom Functions ]]
local function map(mode, lhs, rhs, opts)
  local options = { noremap=true, silent=true }
  if opts then
    options = vim.tbl_extend('force', options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- [[ Setting options ]]
-- See `:help vim.o`

-- Set highlight on search
vim.o.hlsearch = false

-- Make line numbers default
vim.o.nu = true
vim.o.relativenumber = true

-- Enable mouse mode
vim.o.mouse = "a"

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Decrease update time
vim.o.updatetime = 250
vim.wo.signcolumn = "yes"

-- Set colorscheme
-- vim.o.termguicolors = true
-- vim.cmd([[colorscheme gruvbox]])

vim.o.background = "dark" -- or "light" for light mode
vim.cmd([[colorscheme gruvbox]])
-- setup must be called before loading the colorscheme
-- Default options:
require("gruvbox").setup({
  undercurl = true,
  underline = true,
  bold = true,
  italic = true,
  strikethrough = true,
  invert_selection = false,
  invert_signs = false,
  invert_tabline = false,
  invert_intend_guides = false,
  inverse = true, -- invert background for search, diffs, statuslines and errors
  contrast = "", -- can be "hard", "soft" or empty string
  palette_overrides = {},
  overrides = {},
  dim_inactive = false,
  transparent_mode = false,
})
vim.cmd("colorscheme gruvbox")

-- vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
-- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })

-- Set completeopt to have a better completion experience
vim.o.completeopt = "menuone,noselect"

-- [[ Basic Keymaps ]]
-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Remap the ESC key
local options = { noremap = true }
vim.keymap.set("i", "jk", "<Esc>", options)
vim.keymap.set("i", "kj", "<Esc>", options)

-- Remap tabpage switching
map('n', '<M-q>', '<cmd>tabclose<cr>')
map('n', '<M-w>', '<cmd>tabnew %<cr>')
map('n', '<M-t>', '<cmd>tabnew<cr>')
map('n', '<M-s>', '<cmd>tabnext<cr>')
map('n', '<M-a>', '<cmd>tabprevious<cr>')

-- Change split orientation
map('n', '<leader>th', '<C-w>t<C-w>K') -- change vertical to horizontal
map('n', '<leader>tv', '<C-w>t<C-w>H') -- change horizontal to vertical

-- Move around splits using Ctrl + {h,j,k,l}
map('n', '<leader>h', '<C-w>h')
map('n', '<leader>j', '<C-w>j')
map('n', '<leader>k', '<C-w>k')
map('n', '<leader>l', '<C-w>l')

-- Reload configuration without restarting nvim
map('n', '<leader>r', ':so %<CR>')

-- Fast saving with <leader> and w
map('n', '<leader>w', ':w<CR>')

-- Close all windows and exit from Neovim with <leader> and q
map('n', '<leader><leader>q', ':qa!<CR>')




-- Make 4 sized tabs
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.scrolloff = 10

vim.opt.updatetime = 50
--

-- ALE Configuration
vim.g.ale_linters = {
	python = {
		"mypy",
		"flake8",
		"pycln",
		-- "pydocstyle"
	},
	lua = {
		"selene",
		-- 'luacheck'
		-- 'lua_language_server'
	},
}

vim.g.ale_fixers = {
	python = {
		"add_blank_lines_for_python_control_statements", -- Add blank lines before control statements.
		"autoflake", -- Fix flake issues with autoflake.
		"autoimport", -- Fix import issues with autoimport.
		"autopep8", -- Fix PEP8 issues with autopep8.
		-- 'black', -- Fix PEP8 issues with black.
		"isort", -- Sort Python imports with isort.
		"pycln", -- remove unused python import statements
		-- 'pyflyby', -- Tidy Python imports with pyflyby.
		"remove_trailing_lines", -- Remove all blank lines at the end of a file.
		-- 'reorder-python-imports', -- Sort Python imports with reorder-python-imports.
		-- 'ruff', -- A python linter/fixer for Python written in Rust
		"trim_whitespace", -- Remove all trailing whitespace characters at the end of every line.
		-- 'yapf', -- Fix Python files with yapf.
	},
	lua = {
		"stylua",
		"remove_trailing_lines", -- Remove all blank lines at the end of a file.
		"trim_whitespace", -- Remove all trailing whitespace characters at the end of every line.
	},
}

-- Ale config

vim.g.ale_python_flake8_options = "--max-line-length 100"
vim.g.ale_sign_error = "E"
vim.g.ale_sign_warning = "W"
vim.g.ale_echo_msg_error_str = "E"
vim.g.ale_echo_msg_warning_str = "W"
vim.g.ale_echo_msg_format = "[%linter%] %s [%severity%]"
vim.g.ale_fix_on_save = 1
vim.g.ale_disable_lsp = 1
--

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank()
	end,
	group = highlight_group,
	pattern = "*",
})

require("transparent").setup({
	enable = true, -- boolean: enable transparent
	extra_groups = { -- table/string: additional groups that should be cleared
		-- In particular, when you set it to 'all', that means all available groups
		-- "all",
		-- example of akinsho/nvim-bufferline.lua
		"BufferLineTabClose",
		"BufferlineBufferSelected",
		"BufferLineFill",
		"BufferLineBackground",
		"BufferLineSeparator",
		"B:ufferLineIndicatorSelected",
	},
	exclude = {}, -- table: groups you don't want to clear
	ignore_linked_group = true, -- boolean: don't clear a group that links to another group
})

-- Set lualine as statusline
-- See `:help lualine.txt`
require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'gruvbox',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = false,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    }
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {}
}


-- Enable Comment.nvim
require("Comment").setup()

-- Enable `lukas-reineke/indent-blankline.nvim`
-- See `:help indent_blankline.txt`
require("indent_blankline").setup({
	char = "┊",
	show_trailing_blankline_indent = false,
})

-- Gitsigns
-- See `:help gitsigns.txt`
require("gitsigns").setup({
	signs = {
		add = { text = "+" },
		change = { text = "~" },
		delete = { text = "_" },
		topdelete = { text = "‾" },
		changedelete = { text = "~" },
	},
})

-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require("telescope").setup({
	defaults = {
		mappings = {
			i = {
				["<C-u>"] = false,
				["<C-d>"] = false,
			},
		},
	},
})

-- Enable telescope fzf native, if installed
pcall(require("telescope").load_extension, "fzf")

-- See `:help telescope.builtin`
vim.keymap.set("n", "<leader>rf", require("telescope.builtin").oldfiles, { desc = "[rf] Find recently opened files" })
vim.keymap.set("n", "<leader><space>", require("telescope.builtin").buffers, { desc = "[ ] Find existing buffers" })
vim.keymap.set("n", "<leader>/", function()
	-- You can pass additional configuration to telescope to change theme, layout, etc.
	require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
		winblend = 10,
		previewer = false,
	}))
end, { desc = "[/] Fuzzily search in current buffer]" })

vim.keymap.set("n", "<leader>sf", require("telescope.builtin").find_files, { desc = "[S]earch [F]iles" })
vim.keymap.set("n", "<leader>sh", require("telescope.builtin").help_tags, { desc = "[S]earch [H]elp" })
vim.keymap.set("n", "<leader>sw", require("telescope.builtin").grep_string, { desc = "[S]earch current [W]ord" })
vim.keymap.set("n", "<leader>sg", require("telescope.builtin").live_grep, { desc = "[S]earch by [G]rep" })
vim.keymap.set("n", "<leader>sd", require("telescope.builtin").diagnostics, { desc = "[S]earch [D]iagnostics" })

-- Setup Harpoon keybindings
-- Terminal commands
vim.keymap.set("n", "<C-a>", function()
	require("harpoon.mark").add_file()
end, { desc = "[A]dd mark" })
vim.keymap.set("n", "<C-f>", function()
	require("harpoon.ui").toggle_quick_menu()
end, { desc = "[F]ind files" })

-- vim.keymap.set("n", "<Alt-1>", function()
-- 	require("harpoon.ui").nav_file(1)
-- end, { desc = "First file" })
-- vim.keymap.set("n", "<Alt-2>", function()
-- 	require("harpoon.ui").nav_file(2)
-- end, { desc = "Second file" })
-- vim.keymap.set("n", "<Alt-3>", function()
-- 	require("harpoon.ui").nav_file(3)
-- end, { desc = "Third file" })
-- vim.keymap.set("n", "<Alt-4>", function()
-- 	require("harpoon.ui").nav_file(4)
-- end, { desc = "Fourth file" })
--

-- Navigation key bindings
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("x", "<leader>p", '"_dP')

vim.keymap.set("n", "<leader>y", '"+y')
vim.keymap.set("n", "<leader>yy", '"+yy')
vim.keymap.set("v", "<leader>y", '"+y')
vim.keymap.set("n", "<leader>Y", '"+Y')

vim.keymap.set("n", "<leader>d", '"_d')
vim.keymap.set("v", "<leader>d", '"_d')

vim.keymap.set("n", "<leader>s", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>")
--

-- More remaps
vim.keymap.set("n", "<leader>nt", vim.cmd.Ex)
vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeShow)
vim.keymap.set("n", "<leader>gf", require("telescope.builtin").git_files, { desc = "[G]it [F]iles" })

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
--

-- Git remaps
-- Stage/reset individual hunks under cursor in a file
vim.keymap.set("n", "<Leader>gs", ":Gitsigns stage_hunk<CR>")
vim.keymap.set("n", "<Leader>gr", ":Gitsigns reset_hunk<CR>")
vim.keymap.set("n", "<Leader>gu", ":Gitsigns undo_stage_hunk<CR>")

-- Stage/reset all hunks in a file
vim.keymap.set("n", "<Leader>gS", ":Gitsigns stage_buffer<CR>")
vim.keymap.set("n", "<Leader>gU", ":Gitsigns reset_buffer_index<CR>")
vim.keymap.set("n", "<Leader>gR", ":Gitsigns reset_buffer<CR>")

-- Open git status in interative window (similar to lazygit)
vim.keymap.set("n", "<Leader>gg", ":Git<CR>")

-- Show `git status output`
vim.keymap.set("n", "<Leader>gst", ":Git status<CR>")

-- Open commit window (creates commit after writing and saving commit msg)
vim.keymap.set("n", "<Leader>gc", ":Git commit | startinsert<CR>")

-- Other tools from fugitive
vim.keymap.set("n", "<Leader>gdf", ":Git difftool<CR>")
vim.keymap.set("n", "<Leader>gm", ":Git mergetool<CR>")
vim.keymap.set("n", "<Leader>g|", ":Gvdiffsplit<CR>")
vim.keymap.set("n", "<Leader>g_", ":Gdiffsplit<CR>")

-- Keymap to autogenerate docstring
vim.keymap.set("n", "<F3>", ":DogeGenerate numpy<CR>")

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
require("nvim-treesitter.configs").setup({
	-- Add languages to be installed here that you want installed for treesitter
	ensure_installed = { "c", "cpp", "go", "lua", "python", "rust", "typescript", "help", "vim" },

	highlight = { enable = true },
	indent = { enable = true, disable = { "python" } },
	incremental_selection = {
		enable = true,
		keymaps = {
			init_selection = "<c-space>",
			node_incremental = "<c-space>",
			scope_incremental = "<c-s>",
			node_decremental = "<c-backspace>",
		},
	},
	textobjects = {
		select = {
			enable = true,
			lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
			keymaps = {
				-- You can use the capture groups defined in textobjects.scm
				["aa"] = "@parameter.outer",
				["ia"] = "@parameter.inner",
				["af"] = "@function.outer",
				["if"] = "@function.inner",
				["ac"] = "@class.outer",
				["ic"] = "@class.inner",
			},
		},
		move = {
			enable = true,
			set_jumps = true, -- whether to set jumps in the jumplist
			goto_next_start = {
				["]m"] = "@function.outer",
				["]]"] = "@class.outer",
			},
			goto_next_end = {
				["]M"] = "@function.outer",
				["]["] = "@class.outer",
			},
			goto_previous_start = {
				["[m"] = "@function.outer",
				["[["] = "@class.outer",
			},
			goto_previous_end = {
				["[M"] = "@function.outer",
				["[]"] = "@class.outer",
			},
		},
		swap = {
			enable = true,
			swap_next = {
				["<leader>a"] = "@parameter.inner",
			},
			swap_previous = {
				["<leader>A"] = "@parameter.inner",
			},
		},
	},
})

-- Diagnostic keymaps
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float)
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist)

-- LSP settings.
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
	-- NOTE: Remember that lua is a real programming language, and as such it is possible
	-- to define small helper and utility functions so you don't have to repeat yourself
	-- many times.
	--
	-- In this case, we create a function that lets us more easily define mappings specific
	-- for LSP related items. It sets the mode, buffer and description for us each time.
	local nmap = function(keys, func, desc)
		if desc then
			desc = "LSP: " .. desc
		end

		vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
	end

	nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
	nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

	nmap("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
	nmap("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
	nmap("gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
	nmap("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")
	nmap("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
	nmap("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

	-- See `:help K` for why this keymap
	nmap("K", vim.lsp.buf.hover, "Hover Documentation")
	nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")

	-- Lesser used LSP functionality
	nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
	nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
	nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
	nmap("<leader>wl", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, "[W]orkspace [L]ist Folders")

	-- Create a command `:Format` local to the LSP buffer
	vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
		vim.lsp.buf.format()
	end, { desc = "Format current buffer with LSP" })
end

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
local servers = {
	-- clangd = {},
	-- gopls = {},
	-- pyright = {},
	-- rust_analyzer = {},
	-- tsserver = {},

	-- pylsp = {
	--   pylsp = {
	--     -- configurationSources = {"flake8"},
	--     plugins = {
	--       pycodestyle = {enabled = false},
	--       flake8 = {
	--         -- enabled = true,
	--         -- enabled = true,
	--         enabled = false,
	--         -- ignore = {},
	--         -- maxLineLength = 100,
	--         -- maxComplexity = 10
	--       },
	--       -- mypy = {enabled = true, live_mode = true},
	--       mypy = {enabled = false, live_mode = true},
	--       -- isort = {enabled = true},
	--       isort = {enabled = false},
	--       yapf = {enabled = false},
	--       pylint = {enabled = false},
	--       pydocstyle = {
	--         -- enabled = true,
	--         enabled = false,
	--       --  ignore = {"D100"}
	--       },
	--       pyflakes = { enabled = false },
	--       mccabe = {enabled = false},
	--       preload = {enabled = false},
	--       rope_completion = {enabled = false}
	--     }
	--   }
	-- },
	pyright = {},
	lua_ls = {
		Lua = {
			workspace = { checkThirdParty = false },
			telemetry = { enable = false },
			diagnostics = {
				-- Get the language server to recognize the `vim` global
				globals = { "vim" },
			},
		},
	},
}

-- Setup neovim lua configuration
require("neodev").setup()
--
-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

-- Setup mason so it can manage external tooling
require("mason").setup()

-- Ensure the servers above are installed
local mason_lspconfig = require("mason-lspconfig")

mason_lspconfig.setup({
	ensure_installed = vim.tbl_keys(servers),
})

mason_lspconfig.setup_handlers({
	function(server_name)
		require("lspconfig")[server_name].setup({
			capabilities = capabilities,
			on_attach = on_attach,
			settings = servers[server_name],
		})
	end,
})

-- Turn on lsp status information
require("fidget").setup()

-- nvim-cmp setup
local cmp = require("cmp")
local luasnip = require("luasnip")

cmp.setup({
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
		["<C-d>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<CR>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		}),
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			else
				fallback()
			end
		end, { "i", "s" }),
		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { "i", "s" }),
	}),
	sources = {
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
	},
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
