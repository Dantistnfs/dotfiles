require('packer').startup({
  function(use)
    -- Plugin manager
    use({'wbthomason/packer.nvim'})
    -- Startup time
    use({'dstein64/vim-startuptime'})
    -- Async LUA
    use({"nvim-lua/plenary.nvim"})
    -- Guess indents
    use({'tpope/vim-sleuth'})
    -- Personal wiki
    use({'vimwiki/vimwiki'})
    -- Devicons for nerdfont 
    use({'kyazdani42/nvim-web-devicons'})
    -- Dashboard
    use({
      'goolord/alpha-nvim',
      requires = { 'kyazdani42/nvim-web-devicons' },
      config = function()
        require('greeter_config')
      end
    })
    -- Top line with open buffers
    -- use {'akinsho/bufferline.nvim', requires = 'kyazdani42/nvim-web-devicons'}
    -- use {
    --   'romgrk/barbar.nvim',
    --   requires = {'kyazdani42/nvim-web-devicons'}
    -- }
    use({
    'noib3/nvim-cokeline',
    requires = 'kyazdani42/nvim-web-devicons', -- If you want devicons
    config = function()
      require('cokeline').setup()
    end
    })
    -- Bottom line with open project
    use {'nvim-lualine/lualine.nvim',
      requires = {'kyazdani42/nvim-web-devicons', opt = true}
    }
    -- Show lines on ident levels
    use({'Yggdroot/indentLine'})
    -- Fuzzy search
    use {
      'nvim-telescope/telescope.nvim',
      requires = {'nvim-lua/plenary.nvim'}
    }
    -- Todo ,warning highlight
    use({
      "folke/todo-comments.nvim",
      requires = "nvim-lua/plenary.nvim",
      config = function()
        require("todo-comments").setup {
          -- your configuration comes here
          -- or leave it empty to use the default settings
          -- refer to the configuration section below
        }
      end
    })

    -- Advenced syntax highliting
    use 'nvim-treesitter/nvim-treesitter'
    -- Fallback syntax if treesitter doesn't support or package not installed
    use 'sheerun/vim-polyglot'
    -- BDS syntax highliting
    use 'serine/bdsSyntaxHighlight'
    -- Lark syntax highliting
    use 'lark-parser/vim-lark-syntax'
    -- Colourschemes
    use 'KabbAmine/yowish.vim'
    use 'ayu-theme/ayu-vim'
    use 'rebelot/kanagawa.nvim'
    -- LSP
    use 'neovim/nvim-lspconfig'
    -- Testing
    use 'vim-test/vim-test'
    -- Completion
    use 'hrsh7th/nvim-cmp'
    use 'hrsh7th/cmp-nvim-lsp' -- LSP source for nvim-cmp
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/cmp-cmdline'
    -- Snippets
    use 'L3MON4D3/LuaSnip' -- Snippets plugin
    use 'saadparwaiz1/cmp_luasnip' -- Snippets source for nvim-cmp
    use 'rafamadriz/friendly-snippets' -- Snippets 

    -- File tree
    use {
      'kyazdani42/nvim-tree.lua',
      requires = {'kyazdani42/nvim-web-devicons'}
    }
    -- Fast moves across files
    use 'ggandor/lightspeed.nvim'

    -- Git
    use { 'TimUntersberger/neogit', requires = 'nvim-lua/plenary.nvim' }

    -- Saving Session
    -- use {'rmagatti/auto-session'}
    -- Searchin session with Telescope
    -- use { 'rmagatti/session-lens',
    --   requires = {'rmagatti/auto-session', 'nvim-telescope/telescope.nvim'},
    -- }

    use({
      "folke/persistence.nvim",
      event = "BufReadPre", -- this will only start session saving when an actual file was opened
      module = "persistence",
      config = function()
        require("persistence").setup()
      end,
    })
    -- Session alternative to auto-session
    use {"ahmedkhalf/project.nvim"}

    -- Terminal
    use {"akinsho/toggleterm.nvim"}

    -- Noitifications (GIT/Updates/Errors)
    use {'rcarriga/nvim-notify'}

    use {'willchao612/vim-diagon'}

    -- Possible to install, but still testing
    -- https://github.com/mfussenegger/nvim-dap -- debug adapter protocol
  end
})


-- Auto session 
vim.o.sessionoptions="blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal"
require("telescope").load_extension("projects")


vim.g.bufferline = {
  animation = false,
  closable = false,
  clickable = false
}

-- Enable lua and buffer line
require('lualine').setup()
-- require("bufferline").setup{
--   options = {
--     diagnostics = "nvim_lsp",
--     tab_size = 22,
--     max_name_length = 22,
--     show_buffer_close_icons = false, -- I don't use mouse anyway
--     show_close_icon = false,
--     separator_style = "thick",
--     offsets = {{filetype = "NvimTree", text = "File Explorer", text_align = "left"}},
--     diagnostics_indicator = function(count, level, diagnostics_dict, context)
--       local icon = level:match("error") and " " or " "
--       return " " .. icon .. count
--     end
--   }
-- }

--require('barbar').setup()

-- Libnotify
require('notify').setup()
vim.notify = require('notify')


-- Auto-session
-- local defaults = {
--   pre_save_cmds = { 'NvimTreeClose', 'cclose', 'lua vim.notify.dismiss()' },
--   post_restore_cmds = { 'NvimTreeRefresh' },
--   auto_session_enabled = true,
--   auto_save_enabled = true,
--   auto_restore_enabled = false,
-- }
-- 
-- require('auto-session').setup(defaults)

-- Add additional capabilities supported by nvim-cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

local lspconfig = require('lspconfig')

-- Enable some language servers with the additional completion capabilities offered by nvim-cmp
local servers = { 'rust_analyzer', 'pyright', 'jedi_language_server' , 'denols'}
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    -- on_attach = my_custom_on_attach,
    capabilities = capabilities,
  }
end
-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- luasnip setup
local luasnip = require 'luasnip'

require("luasnip/loaders/from_vscode").lazy_load()

-- nvim-cmp setup
local cmp = require 'cmp'
cmp.setup {
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = {
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<Plug>luasnip-expand-or-jump', true, true, true), '')
      else
        fallback()
      end
    end,
    ['<S-Tab>'] = function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<Plug>luasnip-jump-prev', true, true, true), '')
      else
        fallback()
      end
    end,
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'buffer' },
    { name = 'path' },
  },
  formatting = {
    format = function(entry, vim_item)
      vim_item.menu = ({
        nvim_lsp = '[L]',
        emoji    = '[E]',
        path     = '[F]',
        calc     = '[C]',
        vsnip    = '[S]',
        buffer   = '[B]',
      })[entry.source.name]
      return vim_item
    end
  }
}

-- NvimTree config
require'nvim-tree'.setup {
  disable_netrw       = true,
  hijack_netrw        = true,
  open_on_setup       = true,
  ignore_ft_on_setup  = {'alpha'},
  open_on_tab         = true,
  hijack_cursor       = true,
  update_cwd          = true,
  diagnostics = {
    enable = false,
    icons = {
      hint = "",
      info = "",
      warning = "",
      error = "",
    }
  },
  update_focused_file = {
    enable      = true,
    update_cwd  = true,
    ignore_list = {}
  },
  system_open = {
    cmd  = nil,
    args = {}
  },
  filters = {
    dotfiles = false,
    custom = {}
  },
  git = {
    enable = true,
    ignore = true,
    timeout = 500,
  },
  view = {
    width = 35,
    hide_root_folder = false,
    side = 'left',
    mappings = {
      custom_only = false,
      list = {}
    },
    number = false,
    relativenumber = false
  },
  trash = {
    cmd = "trash",
    require_confirm = true
  }
}


local configs = require'nvim-treesitter.configs'
configs.setup {
  ensure_installed = {'rust','python','c','bash','lua', 'yaml', 'toml', 'regex', 'json', 'json5', 'typescript','javascript'},
  highlight = {
    enable = true,
  }
}


require'lspconfig'.jedi_language_server.setup{}


vim.wo.number = true
vim.opt.termguicolors = true
-- Set colourscheme
vim.o.background = 'dark'
vim.cmd('colorscheme ayu')
-- Nope
-- require('onedarkpro').load()
vim.g.indentLine_fileTypeExclude={'alpha'}
vim.g.vimwiki_list = {
    {
        path = '~/syncthing/vimwiki/', 
        syntax = 'markdown',
        ext = '.md'
    }
}

opts = {silent= true, noremap=true}
-- Mappings
-- Terminal
vim.api.nvim_set_keymap("n", "<C-x>", "<cmd>ToggleTerm<CR>", opts)
vim.api.nvim_set_keymap("t", "<C-x>", "<cmd>ToggleTerm<CR>", opts)

-- NvimTreeToggle
vim.api.nvim_set_keymap("n", "<C-b>", ":NvimTreeToggle<CR>", { silent = true })
vim.api.nvim_set_keymap("n", "<C-z>", ":NvimTreeFindFile<CR>", { silent = true })
-- NeoGit
-- :NeoGit
-- Telescope
-- " Using Lua functions
-- nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
-- nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
-- nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
-- nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>
--
-- NeoTest
vim.api.nvim_set_keymap("n", "<Leader>tl", "<cmd>TestLast<CR>", opts)
vim.api.nvim_set_keymap("n", "<Leader>tf", "<cmd>TestFile<CR>", opts)
vim.api.nvim_set_keymap("n", "<Leader>ts", "<cmd>TestSuite<CR>", opts)
vim.api.nvim_set_keymap("n", "<Leader>tn", "<cmd>TestNearest<CR>", opts)

vim.api.nvim_set_keymap("n", "gt", ":bnext<CR>", opts)
vim.api.nvim_set_keymap("n", "gT", ":bprevious<CR>", opts)


-- restore the session for the current directory
vim.api.nvim_set_keymap("n", "<leader>qs", "<cmd>lua require('persistence').load()<cr>", opts)
-- restore the last session
vim.api.nvim_set_keymap("n", "<leader>ql", "<cmd>lua require('persistence').load({ last = true })<cr>", opts)
-- stop Persistence => session won't be saved on exit
vim.api.nvim_set_keymap("n", "<leader>qd", "<cmd>lua require('persistence').stop()<cr>", opts)
