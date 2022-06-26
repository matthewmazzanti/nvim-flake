-- PLUGIN: nvim-telescope
-- HOMEPAGE: https://github.com/nvim-telescope/telescope.nvim
local telescope = require("telescope")
local actions = require("telescope.actions")
local builtin = require("telescope.builtin")
local utils = require("telescope.utils")

telescope.setup({
    defaults = {
        layout_strategy = "vertical",
        layout_config = {
            vertical = {
                prompt_position = "top"
            }
        },
        sorting_strategy = "ascending",
        prompt_title = false,
        results_title = false,
        path_display = { "truncate" },
        mappings = {
            i = {
                ["<esc>"] = actions.close
            }
        }
    },
    pickers = {
        find_files = {
            find_command = {
                fdPath,
                "--type", "f",
                "--hidden",
                "--exclude", ".git",
                "--strip-cwd-prefix"
            }
        }
    },
    extensions = {
        fzf = {
            override_file_sorter = true,
            override_generic_sorter = true
        }
    }
})

local function dir_files()
    return builtin.find_files({
        cwd = utils.buffer_dir(),
        prompt_title = "Local Files"
    })
end

local function spell()
    return builtin.spell_suggest({
        layout_strategy = "cursor",
        layout_config = {
            height = 10,
            width = 35,
        },
        prompt_title = "Spell",
        sorting_strategy = "ascending",
    })
end

vim.cmd([[
nnoremap <leader>f <cmd>lua plugins.telescope.files()<cr>
nnoremap <leader>l <cmd>lua plugins.telescope.dir_files()<cr>
nnoremap <leader>b <cmd>lua plugins.telescope.buffers()<cr>
nnoremap <leader>j <cmd>lua plugins.telescope.jumps()<cr>
nnoremap z= <cmd>lua plugins.telescope.spell()<cr>
]])

return {
    files = builtin.find_files,
    dir_files = dir_files,
    buffers = builtin.buffers,
    jumps = builtin.jumps,
    spell = spell,
    lsp = {
        defs = builtin.lsp_definitions,
        impls = builtin.lsp_implementations,
        refs = builtin.lsp_references,
        types = builtin.lsp_types,
    }
}
