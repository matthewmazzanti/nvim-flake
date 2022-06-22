-- GENERAL CONFIG --

-- Show numbers on each line next to text. Relative numbers for jumps
-- relativenumber may be a bit heavy on low-power systems
vim.opt.number = true
vim.opt.relativenumber = true

-- Movement stuff
-- Allow for mouse
vim.opt.mouse = "a"
-- TODO: Why is this here?
vim.opt.startofline = false
-- TODO: This still needed?
vim.opt.backspace = {"indent", "eol", "start"}


-- Line wrapping
vim.opt.colorcolumn = "101"
vim.opt.textwidth = 100
-- HELP: `fo-table`
-- May be more options to explore here
vim.opt.formatoptions = table.concat({
  "c", -- Auto wrap comments
  "r", -- Add comment leader on <CR> in insert mode
  "o", -- Add comment leader when hitting "O" or "o"
  "j", -- Remove comment leader when joining lines
  "q", -- Format comments with gq
  "l", -- Don't format long lines by default
}, "")
vim.opt.linebreak = true
vim.opt.wrap = false


-- Indentation stuff
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true

vim.opt.smarttab = true
vim.opt.autoindent = true
vim.opt.smartindent = true

-- Incremental search and better caps handling
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Nice visualization of trailing space/tabs
vim.opt.list = true
vim.opt.listchars = {
    tab = "» ",
    extends = "›",
    precedes = "‹",
    nbsp = "·",
    trail = "·",
}

-- Persistent undo
vim.opt.undofile = true

-- Auto-read changed files
vim.opt.autoread = true

-- Don't show mode (using lualine)
vim.opt.showmode = false

-- Always show sign column for marks, errors
vim.opt.signcolumn = "yes"

-- TODO: What does this do?
vim.opt.shortmess:append("c")

-- Set leader key for other commands
vim.g.mapleader = ";"

-- Copy to system clipboard where available
vim.opt.clipboard = "unnamedplus"

-- TODO: Port to Lua?
vim.cmd([[
" Increase speed of mouse scrolling
map <silent> <ScrollWheelUp> 5<C-Y>
map <silent> <ScrollWheelDown> 5<C-E>

" File types
autocmd BufRead,BufNewFile *.conf setfiletype conf
autocmd BufRead,BufNewFile *.nix setfiletype nix
autocmd BufRead,BufNewFile .envrc setfiletype bash
]])
