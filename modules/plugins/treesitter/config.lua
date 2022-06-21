-- PLUGIN: Treesitter - better syntax highlighting for most languages
-- HOMEPAGE: https://github.com/nvim-treesitter/nvim-treesitter
local treesitter = require('nvim-treesitter.configs')

treesitter.setup({
    -- Modules and its options go here
    highlight = { enable = true },
    indent = {
        -- TODO: Indentation doesn't seem to work in many languages, at least nix possibly go.
        enable = false,
    },
    textobjects = {
        enable = true,
        select = {
            enable = true,

            keymaps = {
                -- You can use the capture groups defined in textobjects.scm
                -- TODO: More textobjects? These don't seem to work everywhere
                ["af"] = "@function.outer",
                ["if"] = "@function.inner",
                ["ac"] = "@class.outer",
                ["ic"] = "@class.inner",
                ["al"] = "@loop.outer",
                ["il"] = "@loop.inner",
            }
        }
    },
    -- Enable auto-closing tags for html (and some other languages probably)
    autotag = {
        enable = true,
    }
})
