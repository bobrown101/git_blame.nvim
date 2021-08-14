# bobrown101/git-blame.nvim

An unapologetic ripoff of vim-fugitives GBlame .... but written in lua

![Screenshot](images/screenshot-v1.png)

## Install
```
use { 'bobrown101/git-blame.nvim' }

```

## Use
```lua
:lua require('git_blame').run()
```

## Keymap
```lua
vim.api.nvim_set_keymap('n', '<space>g', "<cmd>lua require('git_blame').run()<cr>", { noremap = true, silent = true })
```
