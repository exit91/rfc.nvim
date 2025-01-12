local M = {
  download_index_cmd = { "curl", "-s", "https://www.ietf.org/rfc/rfc-ref.txt" },
  rfc_url_fmt = "https://www.ietf.org/rfc/%s.txt",
}

M.rfc_url = function(rfc) return string.format(M.rfc_url_fmt, rfc) end
M.get_rfc = function(rfc) return { "curl", "-s", M.rfc_url(rfc) } end

M.parse_line = function(line)
  local cols = vim.split(line, "|", { plain = true, trimempty = true })
  if #cols ~= 3 then return end

  local code = vim.trim(cols[1])
  local code_nr = tonumber(code:match("(%d+)"))
  if not code_nr then return end

  local title = string.format("%d. %s", code_nr, cols[3]:match([["(.+)"]]))
  local value = string.format("rfc%d", code_nr)

  return { code = code, value = value, title = title }
end

M.picker = function(_, opts)
  opts = opts or {}

  local pickers = require "telescope.pickers"
  local finders = require "telescope.finders"
  local previewers = require "telescope.previewers"
  local pv_utils = require "telescope.previewers.utils"
  local conf = require("telescope.config").values
  -- local state = require "telescope.state"
  local actions = require "telescope.actions"
  local action_state = require "telescope.actions.state"

  opts.entry_maker = opts.entry_maker or function(entry)
    local p = M.parse_line(entry)
    if not p then return end

    return {
      value = p.value,
      display = p.title,
      ordinal = p.title,
    }
  end

  pickers.new(opts, {
    prompt_title = "RFCs",
    finder = finders.new_oneshot_job(M.download_index_cmd, opts),
    previewer = previewers.new_buffer_previewer {
      title = opts.preview_title or "RFC preview",
      define_preview = function(self, entry)
        pv_utils.job_maker(M.get_rfc(entry.value), self.state.bufnr, {
          bufname = self.state.bufname,
          value = entry.value,
        })
      end,
    },
    sorter = conf.generic_sorter(opts),
    attach_mappings = function(prompt_bufnr, --[[map]] _)
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
        vim.wo[win].number = false

        local function init_buffer(lines)
          vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
          vim.bo[bufnr].modifiable = false
          vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = bufnr })
        end

        local Job = require "plenary.job"
        ---@diagnostic disable-next-line: missing-fields
        Job:new({
          command = "curl",
          args = M.get_rfc(selection.value),
          on_exit = vim.schedule_wrap(function(j) init_buffer(j:result()) end),
        }):start()
      end)
      return true
    end,
  }):find()
end

return M
