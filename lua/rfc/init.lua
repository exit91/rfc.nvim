local curl = require('plenary.curl')
local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local previewers = require "telescope.previewers"
local conf = require("telescope.config").values
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"

return function(_, opts)
  opts = opts or {}

  local response = curl.get("https://www.ietf.org/rfc/rfc-ref.txt", { compressed = true })
  local split_opts = { plain = true, trimempty = false }
  local split = vim.split(response.body, "\n\n", split_opts)
  local results = vim.split(split[2], "\n", split_opts)

  for i, result in ipairs(results) do
    local cols = vim.split(result, "|", { plain = true, trimempty = true })
    local code = cols[1]
    local code_nr = tonumber(code:match("(%d+)"))
    local title = string.format("%d. %s", code_nr, cols[3]:match([["(.+)"]]))
    local value = string.format("rfc%d", code_nr)

    ---@diagnostic disable-next-line: assign-type-mismatch
    results[i] = { code, title, value }
  end

  local function get_rfc(rfc)
    local rfc_response = curl.get(string.format("https://www.ietf.org/rfc/%s.txt", rfc), { compressed = true })
    return vim.split(rfc_response.body, "\n", { plain = true, trimempty = false })
  end

  pickers.new(opts, {
    prompt_title = "RFCs",
    finder = finders.new_table {
      results = results,
      entry_maker = function(entry)
        return {
          value = entry[3],
          display = entry[2],
          ordinal = entry[2],
        }
      end
    },
    previewer = previewers.new_buffer_previewer {
      title = opts.preview_title or "RFC preview",
      define_preview = function(self, entry)
        local lines = get_rfc(entry.value)
        vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, lines)
      end
    },
    sorter = conf.generic_sorter(opts),
    attach_mappings = function(prompt_bufnr, _)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        local lines = get_rfc(selection.value)

        -- create a new tab and paste it into it
        local bufnr = vim.api.nvim_create_buf(false, true)
        local win = vim.api.nvim_open_win(bufnr, false,
          { relative = 'win', row = 3, col = (vim.o.columns - 80) / 2, width = 80, height = vim.o.lines - 6 })
        vim.api.nvim_win_set_buf(win, bufnr)
        vim.api.nvim_set_current_win(win)
        vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
        vim.wo[win].number = false
      end)
      return true
    end,
  }):find()
end
