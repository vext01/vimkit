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
  use 'itchyny/lightline.vim' -- Status bar
  use 'neovim/nvim-lspconfig' -- LSP config helpers
  use 'christoomey/vim-tmux-navigator' -- tmux integration
  use 'jamessan/vim-gnupg' -- GPG support
  use 'ray-x/lsp_signature.nvim' -- Show func sigs
  use 'ntpeters/vim-better-whitespace' -- Highlight trailing whitespace
  use 'farmergreg/vim-lastplace' -- Open files at the last edited place
  use 'lfv89/vim-interestingwords' -- Highlight interesting words
  use 'tomtom/tcomment_vim' -- Comment lines easily
  use 'airblade/vim-gitgutter' -- Diff symbols in gutter
  use 'mhinz/vim-grepper' -- grep tool
  use 'dyng/ctrlsf.vim' -- search/replace
  use 'editorconfig/editorconfig-vim' -- configure indent per-project
  use {'phaazon/hop.nvim', as = 'hop'} -- improved navigation
  use 'stevearc/aerial.nvim' -- class/function browser
  use 'jbyuki/venn.nvim' -- ASCII art drawings
  use 'dstein64/nvim-scrollview' -- Display a scrollbar

  use 'nvim-treesitter/nvim-treesitter' -- Incremental parsing
  use 'nvim-treesitter/nvim-treesitter-textobjects' -- Extra stuff for treesitter
  use 'romgrk/nvim-treesitter-context' -- Auto-collapse code as you scroll

  -- Programming langauges
  use 'rhysd/vim-llvm'
  use 'rust-lang/rust.vim'

  -- Completion
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-nvim-lsp' -- LSP completion.
  use 'hrsh7th/cmp-path' -- Add completion of filesystem paths
  use 'hrsh7th/cmp-buffer' -- Add completion of text in the current buffer

  -- Snippets
  use 'L3MON4D3/LuaSnip'
  use 'SirVer/ultisnips'
  use 'saadparwaiz1/cmp_luasnip'

  -- Fuzzy finder
  use { 'nvim-telescope/telescope.nvim', requires={ 'nvim-lua/plenary.nvim' } }
  use {'nvim-telescope/telescope-fzf-native.nvim', run = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' }

  -- Colour schemes
  use 'sainnhe/gruvbox-material'
  use 'robertmeta/nofrils'
end)

----------
-- gruvbox
----------

vim.g.gruvbox_material_palette = 'mix'
dofile(config_dir .. "/bg.lua")
vim.cmd [[colorscheme gruvbox-material]]

-------------
-- treesitter
-------------

require('nvim-treesitter.configs').setup {
    ensure_installed = { 'c', 'cpp', 'css', 'toml', 'python', 'rust' },
    highlight = {
        enable = true,
        disable = {'latex'},
        -- Currently we have to add Vim's syntax highlighting to avoid every
        -- keyword being highlighted as a spelling error...
        additional_vim_regex_highlighting = true,
    },
    incremental_selection = { enable = true },
    -- Enabling treesitter's indentation currently causes autoindenting to become very wonky.
    -- indent = { enable = true },
    textobjects = { enable = true },
}


-- treesitter-context
require('treesitter-context').setup {
    enable = true,
}

------
-- LSP
------

local nvim_lsp = require 'lspconfig'

function _G.all_diagnostics()
  if vim.lsp.diagnostic.get_count(0, 'Error') > 0 then
    vim.lsp.diagnostic.set_loclist({severity = 'Error'})
  else
    vim.lsp.diagnostic.set_loclist()
  end
end

function _G.next_diagnostic()
  if next(vim.diagnostic.get(0, {severity = 'Error'})) ~= nil then
    vim.diagnostic.goto_next({severity = 'Error'})
  else
    vim.diagnostic.goto_next()
  end
end

function _G.prev_diagnostic()
  if next(vim.diagnostic.get(0, {severity = 'Error'})) ~= nil then
    vim.diagnostic.goto_prev({severity = 'Error'})
  else
    vim.diagnostic.goto_prev()
  end
end

local aerial = require'aerial'
aerial.setup({ default_direction = 'left' })
local on_attach = function(client, bufnr)
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
  --vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gs', [[:split<CR><cmd>lua require('telescope.builtin').lsp_definitions()<CR>]], opts)
  --vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gy', [[<cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>]], opts)

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

require'cmp'.setup {
  sources = {
    { name = 'nvim_lsp' }
  }
}

local capabilities = require('cmp_nvim_lsp').default_capabilities()

if vim.fn.executable('rust-analyzer') then
    require'lspconfig'.rust_analyzer.setup{
          on_attach = on_attach,
          capabilities = capabilities,
    }
end

if vim.fn.executable('clangd') then
    require'lspconfig'.clangd.setup{
          on_attach = on_attach,
          capabilities = capabilities,
    }
end

------------
-- telescope
------------

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

-----------
-- nvim-cmp
-----------

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

------------------------
-- vim-better-whitespace
------------------------

-- Is annoying when writing mail because the mail signature and inlined diffs
-- contain valid trailing whitespace.
vim.g.better_whitespace_filetypes_blacklist = { 'mail', 'diff' }

----------
-- grepper
----------

vim.g['grepper'] = {tools = { 'rg', 'ag', 'grep' }}
vim.api.nvim_set_keymap('n', '<leader>g', ':Grepper<CR>', { noremap = true, silent = true })
-- https://github.com/mhinz/vim-grepper/issues/257
-- vim.api.nvim_set_keymap('n', 'gs', ':Grepper -cword -noprompt<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'gs', ':execute ":Grepper -noprompt -query " .. shellescape(expand("<cword>"))<cr>', { noremap = true, silent = true })

------
-- hop
------

hop = require'hop'.setup{}
vim.api.nvim_set_keymap('n', 'gw', "<cmd>lua require'hop'.hint_words()<cr>", {})
vim.api.nvim_set_keymap('n', 'g^', "<cmd>lua require'hop'.hint_lines()<cr>", {})

-------
-- venn
-------

-- enable or disable keymappings for venn
function _G.toggle_venn()
    local venn_enabled = vim.inspect(vim.b.venn_enabled)
    if(venn_enabled == "nil") then
        vim.b.venn_enabled = true
        vim.cmd[[setlocal ve=all]]
        -- draw a line on HJKL keystokes
        vim.api.nvim_buf_set_keymap(0, "n", "J", "<C-v>j:VBox<cr>", {noremap = true})
        vim.api.nvim_buf_set_keymap(0, "n", "K", "<C-v>k:VBox<cr>", {noremap = true})
        vim.api.nvim_buf_set_keymap(0, "n", "L", "<C-v>l:VBox<cr>", {noremap = true})
        vim.api.nvim_buf_set_keymap(0, "n", "H", "<C-v>h:VBox<cr>", {noremap = true})
        -- draw a box by pressing "f" with visual selection
        vim.api.nvim_buf_set_keymap(0, "v", "f", ":VBox<cr>", {noremap = true})
    else
        vim.cmd[[setlocal ve=]]
        vim.cmd[[mapclear <buffer>]]
        vim.b.venn_enabled = nil
    end
end
-- toggle keymappings for venn using <leader>v
vim.api.nvim_set_keymap('n', '<leader>v', ":lua toggle_venn()<cr>", { noremap = true})

-------------
-- scrollview
-------------

vim.cmd[[hi link ScrollView Search]]

-------------
-- Misc stuff
-------------

-- Highlight the last column a character may occupy on a line.
-- Default is 79, but may be overridden for other file types.
vim.o.textwidth=79
vim.o.colorcolumn="-0"

-- Space bar in normal mode toggles paste mode.
vim.api.nvim_set_keymap('n', '<Space>', ':set paste!<CR>', { noremap = true, silent = true })

-- Insert a C program.
vim.api.nvim_set_keymap('n', ';c', ':set paste<cr>i#include <stdio.h>\n#include <stdlib.h>\n\nint\nmain(int argc, char **argv)\n{\n\treturn (EXIT_SUCCESS);\n}<esc>:set nopaste<cr>', { noremap = true, silent = true})

vim.o.mouse='a' -- Enable mouse support
vim.o.number = true -- Line number gutter
vim.o.clipboard = 'unnamedplus' -- sync with system clipboard
vim.o.undofile = true -- per-file undo
vim.o.inccommand = 'nosplit' -- live substitutions
vim.o.updatetime = 1000 -- update stuff (like the git gutter) quicker

-- Default indents (editorconfig can override)
vim.o.tabstop = 4
vim.o.expandtab = true
vim.o.shiftwidth = 4

-- Smart case search

vim.o.ignorecase = true
vim.o.smartcase = true

-- Spelling.
vim.o.spelllang = 'en_gb'
vim.api.nvim_set_keymap('n', '<C-s>', ':set spell!<CR>', { noremap = true, silent = true })

-- Strip trailing whitespace

vim.api.nvim_set_keymap('n', ';s', ':%s/\\s\\+$//e<CR>',
    { noremap = true, silent = true })

-- Visual mode, cat selected text (for copying from a remote host)

vim.api.nvim_set_keymap('v', ';y', ':w ! /bin/sh -c cat<CR>',
    { noremap = true, silent = true })

-- Load local (non-version-controlled) settings.
dofile(config_dir .. "/local.lua")
