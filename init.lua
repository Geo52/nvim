-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.api.nvim_set_keymap("i", "jk", "<Esc>", {
    noremap = true,
    silent = true
})
vim.wo.relativenumber = true
vim.opt.wrap = false
vim.o.clipboard = "unnamedplus"
vim.opt.shiftwidth = 4
vim.opt.scrolloff = 8
vim.opt.hlsearch = false
vim.opt.termguicolors = true

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({"git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath})
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({{"Failed to clone lazy.nvim:\n", "ErrorMsg"}, {out, "WarningMsg"},
                           {"\nPress any key to exit..."}}, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({{
    "catppuccin/nvim",
    priority = 1000,
    lazy = false,
    config = function()
        vim.cmd.colorscheme("catppuccin")
    end
}, {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    config = function()
        require("nvim-treesitter.configs").setup({
            ensure_installed = {"lua", "python", "javascript", "html", "css"},
            auto_install = true,
            highlight = {
                enable = true -- enable Treesitter-based highlighting
            },
            indent = {
                enable = true -- enable Treesitter-based indentation
            }
        })
    end
}, {
    "mason-org/mason.nvim",
    config = function()
        require("mason").setup()
    end
}, {
    "mason-org/mason-lspconfig.nvim",
    config = function()
        require("mason-lspconfig").setup({
            ensure_installed = {"lua_ls"}
        })
    end
}, {
    "neovim/nvim-lspconfig",
    config = function()
        local lspconfig = require("lspconfig")
        lspconfig.lua_ls.setup({})
    end
}, {
    "nvimtools/none-ls.nvim",
    dependencies = {"nvim-lua/plenary.nvim"},
    config = function()
        local null_ls = require("null-ls")

        null_ls.setup({
            sources = {null_ls.builtins.formatting.stylua, null_ls.builtins.formatting.rubocop,
                       null_ls.builtins.formatting.prettier, null_ls.builtins.diagnostics.rubocop,
                       null_ls.builtins.diagnostics.eslint_d}
        })
        vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})
    end
}, {'HiPhish/rainbow-delimiters.nvim'}})
