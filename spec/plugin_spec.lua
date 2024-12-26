---@module "luassert"

local example = require('telescope._extensions.rfc.init').example

describe('rfc neovim plugin', function()
  it('work as expect', function()
    local result = example()
    assert.is_true(result)
    assert.are_not.same(result, nil)
  end)
end)
