-- GENERAL CONFIG --

-- Show numbers on each line next to text. Relative numbers for jumps
-- Relativenumber may be a bit heavy on low-power systems
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
-- HELP: fo-table
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

-- Don't show mode (using lightline)
vim.opt.showmode = false

-- Always show sign column for marks, errors
vim.opt.signcolumn = "yes"

-- TODO: What does this do?
vim.opt.shortmess:append("c")

-- Set leader key for other commands
vim.g.mapleader = ";"

-- Copy to system clipboard where available
vim.opt.clipboard = "unnamedplus"

-- TODO: Port to lua?
vim.cmd([[
" Increase speed of mouse scrolling
map <silent> <ScrollWheelUp> 5<C-Y>
map <silent> <ScrollWheelDown> 5<C-E>

" Filetypes
autocmd BufRead,BufNewFile *.conf setfiletype conf
autocmd BufRead,BufNewFile *.nix setfiletype nix
autocmd BufRead,BufNewFile .envrc setfiletype bash
]])


-- PLUGINS --

-- PLUGIN: nvim-compe
-- TODO: DEPRECATED replace this with new completion engine.
-- Replace with https://github.com/hrsh7th/nvim-cmp
vim.opt.completeopt = {"menuone", "noselect"}
require('compe').setup {
    enabled = true;
    autocomplete = true;
    debug = false;
    min_length = 1;
    preselect = 'enable';
    throttle_time = 80;
    source_timeout = 200;
    resolve_timeout = 800;
    incomplete_delay = 400;
    max_abbr_width = 100;
    max_kind_width = 100;
    max_menu_width = 100;
    documentation = {
        -- the border option is the same as `|help nvim_open_win|`
        border = { '', '' ,'', ' ', '', '', '', ' ' },
        winhighlight = "NormalFloat:CompeDocumentation,FloatBorder:CompeDocumentationBorder",
        max_width = 120,
        min_width = 60,
        max_height = math.floor(vim.o.lines * 0.3),
        min_height = 1,
    };

    source = {
        path = true;
        buffer = true;
        calc = true;
        nvim_lsp = true;
        nvim_lua = true;
        vsnip = true;
        ultisnips = true;
        luasnip = true;
    };
}
