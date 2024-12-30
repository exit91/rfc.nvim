local M = {
  index_url = "https://www.ietf.org/rfc/rfc-ref.txt",
  rfc_url_fmt = "https://www.ietf.org/rfc/%s.txt"
}

M.rfc_url = function(rfc) return string.format(M.rfc_url_fmt, rfc) end

M.parse_results = function(results)
  for i, result in ipairs(results) do
    -- RFC0001 |           | Crocker, S., "Host Software", RFC 1, DOI 10.17487/RFC0001, April 1969, <https://www.rfc-editor.org/info/rfc1>.
    local cols = vim.split(result, "|", { plain = true, trimempty = true })
    local code = vim.trim(cols[1])
    local code_nr = tonumber(code:match("(%d+)"))
    local title = string.format("%d. %s", code_nr, cols[3]:match([["(.+)"]]))
    local value = string.format("rfc%d", code_nr)

    results[i] = { code, title, value }
  end
  return results
end

M.download_all = function()
  local curl = require('plenary.curl')
  local response = curl.get(M.index_url, { compressed = true })
  local split_opts = { plain = true, trimempty = false }
  local split = vim.split(response.body, "\n\n", split_opts)
  local results = vim.split(split[2], "\n", split_opts)
  return M.parse_results(results)
end

M.get_rfc = function(rfc)
  local curl = require('plenary.curl')
  local url = M.rfc_url(rfc)
  local rfc_response = curl.get(url, { compressed = true })
  return vim.split(rfc_response.body, "\n", { plain = true, trimempty = false })
end

M.picker = function(_, opts)
  opts = opts or {}

  local pickers = require "telescope.pickers"
  local finders = require "telescope.finders"
  local previewers = require "telescope.previewers"
  local conf = require("telescope.config").values
  local actions = require "telescope.actions"
  local action_state = require "telescope.actions.state"

  pickers.new(opts, {
    prompt_title = "RFCs",
    finder = finders.new_table {
      results = M.download_all(),
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
        vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false,
          M.get_rfc(entry.value))
      end
    },
    sorter = conf.generic_sorter(opts),
    attach_mappings = function(prompt_bufnr, _)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()

        local bufnr = vim.api.nvim_create_buf(false, true)
        local width = 80
        local col = (vim.o.columns - width) / 2
        local nlines = vim.o.lines - 4

        -- create a floating window
        local win = vim.api.nvim_open_win(bufnr, false,
          { relative = 'win', row = 1, col = col, width = width, height = nlines })
        vim.api.nvim_win_set_buf(win, bufnr)
        vim.api.nvim_set_current_win(win)
        -- paste contents in
        vim.api.nvim_buf_set_lines(bufnr, 0, -1, false,
          M.get_rfc(selection.value))
        -- window and buffer local opts
        vim.wo[win].number = false
        vim.bo[bufnr].modifiable = false
        -- use 'q' to close the popup
        vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = bufnr })
      end)
      return true
    end,
  }):find()
end

return M
