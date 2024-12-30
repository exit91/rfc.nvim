local rfc = require('rfc.init')
local assert = require('luassert')
local eq = assert.are.same

-- lua vim.keymap.set('n', '<leader>t', '<cmd>w | PlenaryBustedDirectory lua/tests/ {init="lua/tests/minimal.lua"}<cr>')

describe('rfc.nvim plugin', function()
  it('creates an rfc url', function()
    eq("https://www.ietf.org/rfc/123.txt", rfc.rfc_url(123))
  end)

  it('properly parses an rfc line', function()
    local lines = {
      [[RFC0001 |           | Crocker, S., "Host Software", RFC 1, DOI 10.17487/RFC0001, April 1969, <https://www.rfc-editor.org/info/rfc1>.]]
    }
    local actual = rfc.parse_results(lines)
    eq('table', type(actual))
    eq({ { 'RFC0001', '1. Host Software', 'rfc1' } }, actual)
  end)

  it('downloads all rfcs', function()
    eq('table', type(rfc.download_all()))
  end)

  it('downloads a given rfc', function()
    local actual = rfc.get_rfc('rfc1')
    local expected = "Request for Comments: 1                                          UCLA"
    eq('table', type(actual))
    assert.is_true(vim.tbl_contains(actual, expected))
  end)
end)
