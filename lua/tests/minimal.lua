local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if (vim.uv or vim.loop).fs_stat(lazypath) then
  -- running locally
  vim.opt.rtp:prepend(lazypath)
else
  -- running on CI
  vim.env.LAZY_STDPATH = ".tests"
  load(vim.fn.system("curl -s https://raw.githubusercontent.com/folke/lazy.nvim/main/bootstrap.lua"))()
  vim.opt.rtp:prepend('.tests')
end

require("lazy.minit").setup {
  headless = { log = false },
  spec = {
    { 'nvim-telescope/telescope.nvim', opts = {} },
    { 'nvim-lua/plenary.nvim',         lazy = true },
  }
}
