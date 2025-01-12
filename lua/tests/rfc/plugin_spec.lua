local rfc = require('rfc.init')
local assert = require('luassert')
local eq = assert.are.same
local isnil = assert.is.Nil

-- lua vim.keymap.set('n', '<leader>t', '<cmd>w | PlenaryBustedDirectory lua/tests/ {init="lua/tests/minimal.lua"}<cr>')

describe('rfc.nvim plugin', function()
  it('creates an rfc url', function()
    eq("https://www.ietf.org/rfc/123.txt", rfc.rfc_url(123))
  end)

  it('properly creates a curl command for an rfc', function()
    eq({ "curl", "-s", "https://www.ietf.org/rfc/123.txt" }, rfc.get_rfc(123))
  end)

  it('returns nil for an invalid rfc', function()
    isnil(rfc.parse_line("foo|bar|baz"))
  end)

  it('properly parses an rfc line', function()
    local actual = rfc.parse_line(
      [[RFC0001 |           | Crocker, S., "Host Software", RFC 1, DOI 10.17487/RFC0001, April 1969, <https://www.rfc-editor.org/info/rfc1>.]]
    )
    eq({ code = 'RFC0001', title = '1. Host Software', value = 'rfc1' }, actual)
  end)
end)
