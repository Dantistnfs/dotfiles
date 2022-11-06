vim.g.mapleader = " "
vim.opt.termguicolors = true
vim.bo.expandtab = true

local keymap = vim.api.nvim_set_keymap

-- ./lua/plugins.lua
require("plugins")

if (vim.loop.os_uname().sysname == "Linux") then
  end
