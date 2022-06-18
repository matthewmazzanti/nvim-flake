-- PLUGIN: Treesitter - better syntax highlighting for most languages
-- HOMEPAGE: https://github.com/nvim-treesitter/nvim-treesitter
local treesitter = require('nvim-treesitter.configs')

treesitter.setup({
    -- Modules and its options go here
    highlight = { enable = true },
    indent = {
        -- TODO: Indentation was wonky - check back in on status
        enable = false,
        -- disable = { "go" },
    },
    textobjects = {
        enable = true,
        select = {
            enable = true,

            keymaps = {
                -- You can use the capture groups defined in textobjects.scm
                ["af"] = "@function.outer",
                ["if"] = "@function.inner",
                ["ac"] = "@class.outer",
                ["ic"] = "@class.inner",
                ["al"] = "@loop.outer",
                ["il"] = "@loop.inner",
            }
        }
    }
})
