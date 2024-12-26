return require("telescope").register_extension {
  ---@diagnostic disable-next-line: unused-local
  setup = function(ext_config, _config)
  end,
  exports = { rfc = require("rfc") },
}
