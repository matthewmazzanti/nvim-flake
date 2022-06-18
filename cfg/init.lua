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


-- PLUGIN: CamelCaseMotion
-- HOMEPAGE: https://github.com/bkad/CamelCaseMotion
-- Wanted to be able to move through CamelCase text as well as snake_case code.
-- Particularly helpful for go code
vim.cmd([[
map <silent> w <Plug>CamelCaseMotion_w
map <silent> b <Plug>CamelCaseMotion_b
map <silent> e <Plug>CamelCaseMotion_e
sunmap w
sunmap b
sunmap e
omap <silent> iw <Plug>CamelCaseMotion_iw
xmap <silent> iw <Plug>CamelCaseMotion_iw
omap <silent> ib <Plug>CamelCaseMotion_ib
xmap <silent> ib <Plug>CamelCaseMotion_ib
omap <silent> ie <Plug>CamelCaseMotion_ie
xmap <silent> ie <Plug>CamelCaseMotion_ie
]])

-- PLUGIN: vim-sandwich
-- HOMEPAGE: https://github.com/machakann/vim-sandwich
-- Allows surrounding as a word motion
vim.cmd([[
nmap s <Nop>
xmap s <Nop>
]])

-- PLUGIN: fzf.vim
-- HOMEPAGE: https://github.com/junegunn/fzf.vim
-- File picker and buffer management window
-- TODO: Replace with telescope nvim
vim.cmd([[
let $FZF_DEFAULT_COMMAND = "rg --files --hidden --glob='!.git'"
let g:fzf_layout = {
\   'window': {
\     'width': 90,
\     'height': 25,
\     'highlight': 'GruvboxAquaFaded',
\     'border': 'sharp'
\   }}

nmap <silent> <leader>f :FZF --reverse<CR>
nmap <silent> <leader>b :Buffers<CR>
]])


-- PLUGIN: gruvbox
-- HOMEPAGE: https://github.com/morhetz/gruvbox
-- Color theme
-- TODO: make this into an external pluggable thing?
-- TODO: develop own nix script for color injection?
vim.cmd([[
"" Colortheme
let g:gruvbox_italic = 0
let g:gruvbox_bold = 0
set termguicolors
set background=dark
" Hack for clear bg, clean up
au ColorScheme * hi Normal ctermbg=none guibg=none
colorscheme gruvbox
]])

-- PLUGIN: lightline
-- HOMEPAGE: https://github.com/itchyny/lightline.vim
vim.cmd([[
" Lightline
let g:lightline = { 'colorscheme': 'gruvbox' }
let g:lightline.tabline_subseparator = { 'left': '', 'right': ''}
let g:lightline.tabline = { 'right' : [ [ ] ] }
let g:lightline.tab = {
    \ 'active': [ 'filename', 'modified' ],
    \ 'inactive': [ 'filename', 'modified' ] }
let g:lightline.active = {
    \ 'left': [ [ 'mode', 'paste'], ['readonly', 'relativepath', 'modified'] ],
    \ 'right': [ [ 'lineinfo' ], [ 'percent' ] ] }
]])

-- PLUGIN: vim-closetag
-- HOMEPAGE: https://github.com/alvan/vim-closetag
-- Auto close html and react tags
vim.cmd([[
" Javascript/Typescript settings
let g:closetag_filetypes = 'javascriptreact,typescriptreact'
let g:closetag_regions = {
    \ 'typescriptreact': 'jsxRegion,tsxRegion',
    \ 'javascriptreact': 'jsxRegion',
    \ }
]])
