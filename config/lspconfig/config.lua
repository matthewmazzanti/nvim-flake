-- PLUGIN: lsp_config
-- HOMEPAGE: https://github.com/neovim/nvim-lspconfig
local lspconfig = require("lspconfig")

local on_attach = function(_, bufnr)
    local function set_key(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end

    -- Mappings.
    local opts = { noremap=true, silent=true }

    -- See `:help vim.lsp.*` for documentation on any of the below functions
    -- TODO: Make telescope keybinds rely on setup somehow
    set_key("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
    set_key("n", "gd", "<cmd>lua plugins.telescope.lsp.defs()<CR>", opts)
    set_key("n", "gi", "<cmd>lua plugins.telescope.lsp.impl()<CR>", opts)
    set_key("n", "gr", "<cmd>lua plugins.telescope.lsp.refs()<CR>", opts)
    set_key("n", "gy", "<cmd>lua plugins.telescope.lsp.types()<CR>", opts)

    -- TODO: Reconsider this for opening help files. Possibly make function for if in comments?
    set_key("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
    set_key("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
    set_key("n", "[d", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", opts)
    set_key("n", "]d", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", opts)
    set_key("n", "<leader>a", "<cmd> lua vim.lsp.buf.code_action()<CR>", opts)
end

-- TODO: Make this optional based on availability
local capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())

-- TODO: Make config for this use recursive sub-modules
for name, cmd in pairs(language_servers) do
    lspconfig[name].setup({
        cmd = cmd,
        on_attach = on_attach,
        capabilities = capabilities,
        flags = {
            debounce_text_changes = 150,
        }
    })
end

lspconfig.sumneko_lua.setup({
    -- sumneko_lua passed as string
    cmd = { sumneko_lua },
    on_attach = on_attach,
    capabilities = capabilities,
    flags = {
        debounce_text_changes = 150,
    },
    settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you"re using
                -- (most likely LuaJIT in the case of Neovim)
                version = "LuaJIT",
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = {"vim"},
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = vim.api.nvim_get_runtime_file("", true),
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {
                enable = false,
            },
        },
    },
})
