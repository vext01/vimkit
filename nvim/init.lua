-- Bootstrap lazy pkg manager.

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
    "nvim-lualine/lualine.nvim", -- Status bar
    "neovim/nvim-lspconfig", -- LSP config helpers
    "christoomey/vim-tmux-navigator", -- tmux integration
    "jamessan/vim-gnupg", -- GPG support
    "ray-x/lsp_signature.nvim", -- Show func sigs
    "ntpeters/vim-better-whitespace", -- Highlight trailing whitespace
    "farmergreg/vim-lastplace", -- Open files at the last edited place
    "lfv89/vim-interestingwords", -- Highlight interesting words
    "tomtom/tcomment_vim", -- Comment lines easily
    "airblade/vim-gitgutter", -- Diff symbols in gutter
    "mhinz/vim-grepper", -- grep tool
    "dyng/ctrlsf.vim", -- search/replace
    "editorconfig/editorconfig-vim", -- configure indent per-project
    "phaazon/hop.nvim", -- improved navigation
    "jbyuki/venn.nvim", -- ASCII art drawings
    "dstein64/nvim-scrollview", -- Display a scrollbar
    "tpope/vim-surround", -- add/edit surrounding characters
    "chrisbra/unicode.vim", -- help with inserting unicode characters

    "nvim-treesitter/nvim-treesitter", -- Incremental parsing
    "nvim-treesitter/nvim-treesitter-textobjects", -- Extra stuff for treesitter
    "romgrk/nvim-treesitter-context", -- Auto-collapse code as you scroll

    "j-hui/fidget.nvim", -- status notifier for LSP

    -- Programming langauges
    "rhysd/vim-llvm",
    "rust-lang/rust.vim",

    -- Completion
    "hrsh7th/nvim-cmp", -- Compelter core.
    "hrsh7th/cmp-nvim-lsp", -- LSP completion.
    "hrsh7th/cmp-path", -- Add completion of filesystem paths
    "hrsh7th/cmp-buffer", -- Add completion of text in the current buffer

    -- Fuzzy finder
    { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },

    -- Colour schemes
    "sainnhe/gruvbox-material",
    "robertmeta/nofrils",
}

local lazy_opts = {
    ui = {
        icons = {
            cmd = "⌘",
            config = "🛠",
            event = "📅",
            ft = "📂",
            init = "⚙",
            keys = "🗝",
            plugin = "🔌",
            runtime = "💻",
            source = "📄",
            start = "🚀",
            task = "📌",
            lazy = "💤 ",
        },
    },
}

require("lazy").setup(plugins, lazy_opts)

local config_dir = os.getenv("HOME") .. "/.config/nvim"

----------
-- gruvbox
----------

vim.g.gruvbox_material_palette = "mix"
if vim.fn.filereadable(path) == 1 then
    dofile(config_dir .. "/bg.lua")
end
vim.cmd([[colorscheme gruvbox-material]])

----------
-- lualine
----------

require("lualine").setup({
    options = { theme = "onedark", icons_enabled = false },
})

-------------
-- treesitter
-------------

require("nvim-treesitter.configs").setup({
    ensure_installed = { "c", "cpp", "css", "lua", "markdown", "toml", "python", "rust" },
    highlight = {
        enable = true,
        disable = { "latex" },
        -- Currently we have to add Vim's syntax highlighting to avoid every
        -- keyword being highlighted as a spelling error...
        additional_vim_regex_highlighting = true,
    },
    incremental_selection = { enable = true },
    -- Enabling treesitter's indentation currently causes autoindenting to become very wonky.
    -- indent = { enable = true },
    textobjects = { enable = true },
})

-- treesitter-context
require("treesitter-context").setup({
    enable = true,
    max_lines = 2,
})

----------------
-- lsp_signature
----------------

require("lsp_signature").setup({
    bind = true,
    hint_enable = false,
    handler_opts = { border = "rounded" },
})

------
-- LSP
------

local nvim_lsp = require("lspconfig")

function _G.all_diagnostics()
    if next(vim.diagnostic.get(0)) ~= nil then
        vim.diagnostic.setloclist()
        vim.cmd("lopen")
    end
end

function _G.next_diagnostic()
    if next(vim.diagnostic.get(0, { severity = "Error" })) ~= nil then
        vim.diagnostic.jump({ count = 1, severity = "Error", float = true })
    else
        vim.diagnostic.jump({ count = 1, float = true })
    end
end

function _G.prev_diagnostic()
    if next(vim.diagnostic.get(0, { severity = "Error" })) ~= nil then
        vim.diagnostic.jump({ count = -1, severity = "Error", float = true })
    else
        vim.diagnostic.jump({ count = -1, float = true })
    end
end

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(ev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        if client:supports_method("textDocument/completion") then
            vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = false })
        end

        local opts = { noremap = true, silent = true, buffer = ev.buf }
        local buf = { buffer = ev.buf }
        vim.keymap.set("n", "ga", "<cmd>lua all_diagnostics()<CR>", opts)
        vim.keymap.set("n", "gd", [[<cmd>lua require('telescope.builtin').lsp_definitions()<CR>]], opts)
        vim.keymap.set("n", "gt", [[<cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>]], opts)
        vim.keymap.set("n", "gT", [[<cmd>lua require('telescope.builtin').lsp_dynamic_workspace_symbols()<CR>]], opts)
        vim.keymap.set("n", "ge", "<cmd>lua next_diagnostic()<CR>", opts)
        vim.keymap.set("n", "gE", "<cmd>lua prev_diagnostic()<CR>", opts)
        vim.keymap.set("n", "gh", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
        vim.keymap.set("n", "gH", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
        vim.keymap.set("n", "gl", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
        vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
        vim.keymap.set("n", "gR", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
        vim.keymap.set("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
    end,
})

-- Disable snippets in code completion. Prevents func params being
-- pre-populated when you complete a function.
local capabilities = require("cmp_nvim_lsp").default_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = false
vim.lsp.config("*", { capabilities = capabilities })

if vim.fn.executable("rust-analyzer") == 1 then
    vim.lsp.enable("rust_analyzer")
end

if vim.fn.executable("clangd") == 1 then
    vim.lsp.enable("clangd")
end

-- FIXME: add back lua-language-server
-- FIXME: add back pylsp

---------
-- fidget
---------

require("fidget").setup({
    progress = {
        display = {
            render_limit = 3, -- max 3 lines
        },
    },
})

------------
-- telescope
------------

local actions = require("telescope.actions")
require("telescope").setup({
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
})

local opts = { noremap = true, silent = true }
vim.keymap.set(
    "",
    "<C-b>",
    [[<cmd>lua require('telescope.builtin').buffers({sort_lastused=true, ignore_current_buffer=false, sort_mru=true})<CR>]],
    opts
)
vim.keymap.set("", "<C-p>", [[<cmd>lua require('telescope.builtin').find_files({previewer=false})<CR>]], opts)
vim.keymap.set("n", "<leader>sb", [[<cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<CR>]], opts)
vim.keymap.set("n", "<leader>sd", [[<cmd>lua require('telescope.builtin').grep_string()<CR>]], opts)
vim.keymap.set("n", "<leader>sp", [[<cmd>lua require('telescope.builtin').live_grep()<CR>]], opts)
vim.keymap.set("n", "<leader>?", [[<cmd>lua require('telescope.builtin').oldfiles()<CR>]], opts)

-----------
-- nvim-cmp
-----------

local cmp = require("cmp")
cmp.setup({
    completion = {
        autocomplete = false,
    },
    mapping = cmp.mapping.preset.insert({
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
    }),
    sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "path" },
    }, {
        { name = "buffer" },
    }),
})

------------------------
-- vim-better-whitespace
------------------------

-- Is annoying when writing mail because the mail signature and inlined diffs
-- contain valid trailing whitespace.
vim.g.better_whitespace_filetypes_blacklist = { "mail", "diff" }

----------
-- grepper
----------

vim.g["grepper"] = { tools = { "rg", "ag", "grep" } }
vim.keymap.set("n", "<leader>g", ":Grepper<CR>", { noremap = true, silent = true })
-- Bit of a hack here.
-- https://github.com/mhinz/vim-grepper/issues/257
vim.keymap.set(
    "n",
    "gs",
    ':execute ":Grepper -noprompt -query " .. shellescape(expand("<cword>"))<cr>',
    { noremap = true, silent = true }
)

------
-- hop
------

hop = require("hop").setup({})
vim.keymap.set("n", "gw", "<cmd>lua require'hop'.hint_words()<cr>", {})
vim.keymap.set("n", "g^", "<cmd>lua require'hop'.hint_lines()<cr>", {})

-------
-- venn
-------

-- enable or disable keymappings for venn
function _G.toggle_venn()
    local venn_enabled = vim.inspect(vim.b.venn_enabled)
    if venn_enabled == "nil" then
        vim.b.venn_enabled = true
        vim.cmd([[setlocal ve=all]])
        -- draw a line on HJKL keystokes
        vim.api.nvim_buf_set_keymap(0, "n", "J", "<C-v>j:VBox<cr>", { noremap = true })
        vim.api.nvim_buf_set_keymap(0, "n", "K", "<C-v>k:VBox<cr>", { noremap = true })
        vim.api.nvim_buf_set_keymap(0, "n", "L", "<C-v>l:VBox<cr>", { noremap = true })
        vim.api.nvim_buf_set_keymap(0, "n", "H", "<C-v>h:VBox<cr>", { noremap = true })
        -- draw a box by pressing "f" with visual selection
        vim.api.nvim_buf_set_keymap(0, "v", "f", ":VBox<cr>", { noremap = true })
    else
        vim.cmd([[setlocal ve=]])
        vim.cmd([[mapclear <buffer>]])
        vim.b.venn_enabled = nil
    end
end
-- toggle keymappings for venn using <leader>v
vim.keymap.set("n", "<leader>v", ":lua toggle_venn()<cr>", { noremap = true })

-------------
-- scrollview
-------------

vim.cmd([[hi link ScrollView Search]])

-------------
-- Misc stuff
-------------

-- Highlight the last column a character may occupy on a line.
-- Default is 79, but may be overridden for other file types.
vim.o.textwidth = 79
vim.o.colorcolumn = "-0"

-- Insert a C program.
vim.keymap.set(
    "n",
    ";c",
    ":set paste<cr>i#include <stdio.h>\n#include <stdlib.h>\n\nint\nmain(int argc, char **argv)\n{\n\treturn (EXIT_SUCCESS);\n}<esc>:set nopaste<cr>",
    { noremap = true, silent = true }
)

vim.o.mouse = "a" -- Enable mouse support
vim.o.number = true -- Line number gutter
vim.o.clipboard = "unnamedplus" -- sync with system clipboard
vim.o.undofile = true -- per-file undo
vim.o.inccommand = "nosplit" -- live substitutions
vim.o.updatetime = 1000 -- update stuff (like the git gutter) quicker

-- Default indents (editorconfig can override)
vim.o.tabstop = 4
vim.o.expandtab = true
vim.o.shiftwidth = 4

-- Smart case search

vim.o.ignorecase = true
vim.o.smartcase = true

-- Spelling.
vim.o.spelllang = "en_gb"
vim.keymap.set("n", "<C-s>", ":set spell!<CR>", { noremap = true, silent = true })

-- Strip trailing whitespace

vim.keymap.set("n", ";s", ":%s/\\s\\+$//e<CR>", { noremap = true, silent = true })

-- Visual mode, cat selected text (for copying from a remote host)

vim.keymap.set("v", ";y", ":w ! /bin/sh -c cat<CR>", { noremap = true, silent = true })

-- escape closes floating windows and clears hlsearch.
local function close_floating()
    for _, win in pairs(vim.api.nvim_list_wins()) do
        if vim.api.nvim_win_get_config(win).relative == "win" then
            vim.api.nvim_win_close(win, false)
        end
    end
end

vim.keymap.set("n", "<esc>", function()
    close_floating()
    vim.cmd(":noh")
end, { silent = true, desc = "Remove Search Highlighting, Dismiss Popups" })

-- Load local (non-version-controlled) settings.
dofile(config_dir .. "/local.lua")

-- CPU constantly spinning with rust-analyzer.
-- https://github.com/neovim/neovim/issues/23291
-- Disable the watcher for now...
require("vim.lsp._watchfiles")._watchfunc = function(_, _, _)
    return true
end

-- reread bg.lua on SIGUSR1
vim.api.nvim_create_autocmd("Signal", {
    callback = function()
        vim.lsp.buf.format()
    end,
})
vim.api.nvim_create_autocmd("Signal", {
    pattern = { "SIGUSR1" },
    callback = function()
        if vim.fn.filereadable(path) == 1 then
            dofile(config_dir .. "/bg.lua")
        end
    end,
})
