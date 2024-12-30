local rfc = require('rfc.init')
local assert = require('luassert')

-- lua vim.keymap.set('n', '<leader>t', '<cmd>w | PlenaryBustedDirectory lua/tests/ {init="lua/tests/minimal.lua"}<cr>')

describe('rfc neovim plugin', function()
  it('work as expect', function()
    local result = rfc.picker()
    assert.is_nil(result)
    assert.are.same(result, nil)
  end)
end)
