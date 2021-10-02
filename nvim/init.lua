-- On the first run, do `:PackerInstall` and restart.

local config_dir = os.getenv("HOME") .. '/.config/nvim'

local packer_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(packer_path)) > 0 then
  vim.fn.execute('!git clone https://github.com/wbthomason/packer.nvim ' .. packer_path)
end

vim.api.nvim_exec(
  [[
  augroup Packer
    autocmd!
    autocmd BufWritePost init.lua PackerCompile
  augroup end
]],
  false
)

local use = require('packer').use
require('packer').startup(function()
  use 'wbthomason/packer.nvim' -- Package manager
  use 'rust-lang/rust.vim' -- General Rust stuff
  use 'itchyny/lightline.vim' -- Status bar
  use 'neovim/nvim-lspconfig' -- LSP config helpers
  use 'christoomey/vim-tmux-navigator' -- tmux integration
  use 'jamessan/vim-gnupg' -- GPG support
  use 'ray-x/lsp_signature.nvim' -- Show func sigs

  -- Completion
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-nvim-lsp' -- LSP completion.
  use 'hrsh7th/cmp-path' -- Add completion of filesystem paths
  use 'hrsh7th/cmp-buffer' -- Add completion of text in the current buffer
  use 'saadparwaiz1/cmp_luasnip'

  use 'L3MON4D3/LuaSnip' -- Snippets

  -- Fuzzy finder
  use { 'nvim-telescope/telescope.nvim', requires={ 'nvim-lua/plenary.nvim' } }
  use { 'nvim-telescope/telescope-fzf-native.nvim', requires={ 'nvim-telescope/telescope.nvim' }, run='gmake' }
  
  -- Colour schemes
  use 'sainnhe/gruvbox-material'
  use 'morhetz/gruvbox'
  use 'robertmeta/nofrils'

  --use 'altercation/vim-colors-solarized'
end)

-- gruvbox

vim.o.termguicolors = true
vim.g.gruvbox_material_palette = 'mix'
vim.cmd [[colorscheme gruvbox-material]]
--vim.cmd [[colorscheme nofrils-acme]]

-- LSP

local nvim_lsp = require 'lspconfig'

function _G.all_diagnostics()
  if vim.lsp.diagnostic.get_count(0, 'Error') > 0 then
    vim.lsp.diagnostic.set_loclist({severity = 'Error'})
  else
    vim.lsp.diagnostic.set_loclist()
  end
end

function _G.next_diagnostic()
  if vim.lsp.diagnostic.get_count(0, 'Error') > 0 then
    vim.lsp.diagnostic.goto_next({severity = 'Error'})
  else
    vim.lsp.diagnostic.goto_next()
  end
end

function _G.prev_diagnostic()
  if vim.lsp.diagnostic.get_count(0, 'Error') > 0 then
    vim.lsp.diagnostic.goto_prev({severity = 'Error'})
  else
    vim.lsp.diagnostic.goto_prev()
  end
end

local on_attach = function(_, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  local opts = { noremap = true, silent = true }
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'ga', '<cmd>lua all_diagnostics()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', [[<cmd>lua require('telescope.builtin').lsp_definitions()<CR>]], opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'ge', '<cmd>lua next_diagnostic()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gE', '<cmd>lua prev_diagnostic()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gh', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gH', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gl', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gR', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gs', [[:split<CR><cmd>lua require('telescope.builtin').lsp_definitions()<CR>]], opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gy', [[<cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>]], opts)

  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  vim.cmd [[ command! Format execute 'lua vim.lsp.buf.formatting()' ]]

  require "lsp_signature".on_attach({
    bind = true,
    doc_lines = 0,
    hint_enable = false,
    transparency = 25,
    handler_opts = { border = "single" }
  }, bufnr)
end

local setup = {
  on_attach = on_attach,
  capabilities = capabilities
}
nvim_lsp['rust_analyzer'].setup(setup)

-- telescope

local actions = require('telescope.actions')
require('telescope').setup{
  defaults = {
    layout_strategy = "flex",
    sorting_strategy = "descending",
    mappings = {
      i = {
        ["<C-d>"] = false,
        ["<C-u>"] = false,
        ["<PageDown>"] = actions.move_to_bottom,
        ["<PageUp>"] = actions.move_to_top,
        ["<C-up>"] = actions.preview_scrolling_up,
        ["<C-down>"] = actions.preview_scrolling_down,
      },
      n = {
        ["<C-d>"] = false,
        ["<C-u>"] = false,
        ["<PageDown>"] = actions.move_to_bottom,
        ["<PageUp>"] = actions.move_to_top,
        ["<C-up>"] = actions.preview_scrolling_up,
        ["<C-down>"] = actions.preview_scrolling_down,
      },
    },
  },
  extensions = {
    fzf = {
      fuzzy = true,                    -- false will only do exact matching
      override_generic_sorter = true,  -- override the generic sorter
      override_file_sorter = true,     -- override the file sorter
      case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                       -- the default case_mode is "smart_case"
    }
  }
}
require('telescope').load_extension('fzf')

vim.api.nvim_set_keymap('', '<C-b>', [[<cmd>lua require('telescope.builtin').buffers({sort_lastused=true, ignore_current_buffer=false, sort_mru=true})<CR>]], { noremap=true, silent=true})
vim.api.nvim_set_keymap('', '<C-p>', [[<cmd>lua require('telescope.builtin').find_files({previewer=false})<CR>]], { noremap=true, silent=true})

vim.api.nvim_set_keymap('n', '<leader>sb', [[<cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>sh', [[<cmd>lua require('telescope.builtin').help_tags()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>st', [[<cmd>lua require('telescope.builtin').tags()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>sd', [[<cmd>lua require('telescope.builtin').grep_string()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>sp', [[<cmd>lua require('telescope.builtin').live_grep()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>so', [[<cmd>lua require('telescope.builtin').tags{ only_current_buffer = true }<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>?', [[<cmd>lua require('telescope.builtin').oldfiles()<CR>]], { noremap = true, silent = true })

-- nvim-cmp

local cmp = require 'cmp'
local luasnip = require 'luasnip'
require("luasnip.loaders.from_vscode").load()
cmp.setup {
  completion = {
    autocomplete = false
  },
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
      if vim.fn.pumvisible() == 1 then
        vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<C-n>', true, true, true), 'n')
      elseif luasnip.expand_or_jumpable() then
        vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<Plug>luasnip-expand-or-jump', true, true, true), '')
      else
        fallback()
      end
    end,
    ['<S-Tab>'] = function(fallback)
      if vim.fn.pumvisible() == 1 then
        vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<C-p>', true, true, true), 'n')
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
    { name = 'path' },
    { name = 'buffer' }
  },
}
vim.api.nvim_set_keymap('', '<C-space>', 'lua cmp.complete()', {silent=true,noremap=true})

-- cmp_nvim_lsp

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

-- XXX

--vim.o.background = 'light'
