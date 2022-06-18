local telescope = require("telescope")
local actions = require("telescope.actions")

telescope.setup({
    defaults = {
        layout_strategy = "vertical",
        path_display = { "truncate" },
        mappings = {
            i = {
                ["<esc>"] = actions.close,
            }
        }
    },
    pickers = {
        find_files = {
            find_command = {
                "fd",
                "--type", "f",
                "--hidden",
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

vim.cmd([[
nnoremap <leader>f <cmd>Telescope find_files<cr>
nnoremap <leader>b <cmd>Telescope buffers<cr>
nnoremap <leader>j <cmd>Telescope jumps<cr>
]])
