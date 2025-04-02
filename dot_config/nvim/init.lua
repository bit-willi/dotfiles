-- Setup globals that I expect to be always available.
--  See `./lua/bit/globals.lua` for more information.
require "bit.globals"

if vim.g.neovide then
  vim.g.neovide_cursor_trail_legnth = 0
  vim.g.neovide_cursor_animation_length = 0
end

-- Leader key -> ","
vim.g.mapleader = ","
vim.g.maplocalleader = " "

require "bit.disable_builtin"
require "bit.keymaps"
require "bit.options"

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
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

require("lazy").setup("bit.plugins", {
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
    },
  },
})

