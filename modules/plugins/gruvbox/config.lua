-- PLUGIN: gruvbox
-- HOMEPAGE: https://github.com/morhetz/gruvbox
-- Color theme
-- TODO: make this into an external pluggable thing?
-- TODO: develop own nix script for color injection?

vim.g.gruvbox_italic = 0
vim.g.gruvbox_bold = 0
vim.opt.termguicolors = true
vim.opt.background = "dark"

vim.cmd([[
" Hack for clear bg, clean up
au ColorScheme * hi Normal ctermbg=none guibg=none
colorscheme gruvbox

highlight SignColumn ctermbg=none guibg=none
]])

local function setup(plugins)
    if plugins["telescope"] ~= nil then
        vim.cmd([[
            highlight link TelescopeBorder GruvboxGray
            highlight link TelescopePromptBorder GruvboxGray
            highlight link TelescopeResultsBorder GruvboxGray
            highlight link TelescopePreviewBorder GruvboxGray
        ]])
    end
end

return {
    setup = setup
}
