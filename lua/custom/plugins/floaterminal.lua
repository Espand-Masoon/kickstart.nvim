local state = {
  floating = {
    buf = -1,
    win = -1,
  },
}

local function create_floating_window(opts)
  opts = opts or {}
  local width = opts.width or math.floor(vim.o.columns * 1.0)
  local height = opts.height or math.floor(vim.o.lines * 1.0)

  -- Center the window
  local col = math.floor((vim.o.columns - width) / 2)
  local row = math.floor((vim.o.lines - height) / 2)

  -- Create a buffer if needed
  local buf = nil
  if vim.api.nvim_buf_is_valid(opts.buf) then
    buf = opts.buf
  else
    buf = vim.api.nvim_create_buf(false, true)
  end

  -- Window configuration
  local win_config = {
    relative = 'editor',
    width = width,
    height = height,
    row = row,
    col = col,
    style = 'minimal',
    border = 'rounded',
  }

  local win = vim.api.nvim_open_win(buf, true, win_config)

  return { buf = buf, win = win }
end

local toggle_terminal = function()
  if not vim.api.nvim_win_is_valid(state.floating.win) then
    state.floating = create_floating_window { buf = state.floating.buf }
    if vim.bo[state.floating.buf].buftype ~= 'terminal' then vim.cmd.terminal() end
  else
    vim.api.nvim_win_hide(state.floating.win)
  end
end

-- Commands & Keymaps
vim.api.nvim_create_user_command('FloTerminal', toggle_terminal, {})
vim.keymap.set({ 'n', 't' }, '<space>tt', toggle_terminal)
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>')
