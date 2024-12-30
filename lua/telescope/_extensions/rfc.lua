local rfc = require "rfc"
local telescope = require "telescope"

return telescope.register_extension {
  exports = { rfc = rfc.picker },
}
