local M = {}

local function create_win()
  -- We save handle to window from which we open the navigation
  start_win = vim.api.nvim_get_current_win()
  local startingBuf = vim.api.nvim_command_output("echo expand('%:p')  ")

  vim.api.nvim_command('topleft vnew') -- We open a new vertical window at the far left
  win = vim.api.nvim_get_current_win() -- We save our navigation window handle...
  buf = vim.api.nvim_get_current_buf() -- ...and it's buffer handle.

  -- We should name our buffer. All buffers in vim must have unique names.
  -- The easiest solution will be adding buffer handle to it
  -- because it is already unique and it's just a number.
  vim.api.nvim_buf_set_name(buf, 'GBlame #' .. buf)

  -- Now we set some options for our buffer.
  -- nofile prevent mark buffer as modified so we never get warnings about not saved changes.
  -- Also some plugins treat nofile buffers different.
  -- For example coc.nvim don't triggers aoutcompletation for these.
  vim.api.nvim_buf_set_option(buf, 'buftype', 'nofile')
  -- We do not need swapfile for this buffer.
  vim.api.nvim_buf_set_option(buf, 'swapfile', false)
  -- And we would rather prefer that this buffer will be destroyed when hide.
  vim.api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')
  -- It's not necessary but it is good practice to set custom filetype.
  -- This allows users to create their own autocommand or colorschemes on filetype.
  -- and prevent collisions with other plugins.
  vim.api.nvim_buf_set_option(buf, 'filetype', 'git-blame')

  -- For better UX we will turn off line wrap and turn on current line highlight.
  vim.api.nvim_win_set_option(win, 'wrap', false)
  vim.api.nvim_win_set_option(win, 'cursorline', true)
  vim.api.nvim_win_set_width(win, 40)
  -- set_mappings() -- At end we will set mappings for our navigation.

  -- the grep is an ugly but super performant way to remove everything up until the first occurance of " ("
  -- which strips off the commit hash and filename from the git blame log
  
  vim.api.nvim_command('read!git blame --date human ' .. startingBuf .. ' | grep -o " (.* [0-9]\\+)" | cut -c 3- ' )
  -- vim.api.nvim_command('read!git blame --date human ' .. startingBuf  .. ' |  sed -n "s/ (/&\n/;s/.*\n//p"' )
  vim.cmd('normal gg')
  vim.cmd('normal dd') -- there is an empty line at the top of the file - remove it
end

local function get_current_window()
  return vim.api.nvim_get_current_win()
end

local function get_current_cursor_location(window)
  return vim.api.nvim_win_get_cursor(window)
end

local function set_cursor_position(window, position)
  return vim.api.nvim_win_set_cursor(window, position)
end

function GBlame() 
  local starting_window = get_current_window()

  vim.api.nvim_win_set_option(starting_window, 'scrollbind', true)

  local starting_cursor_location = get_current_cursor_location(starting_window) 

  vim.cmd('normal gg')

  create_win()

  local blame_window = get_current_window()

  set_cursor_position(blame_window, starting_cursor_location)

  vim.api.nvim_win_set_option(starting_window, 'scrollbind', true)

  vim.cmd('normal gg')

  set_cursor_position(starting_window, starting_cursor_location)
end

