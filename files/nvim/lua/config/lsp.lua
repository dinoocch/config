-- Language server specific configs
local nvim_lsp = require("lspconfig")

local on_attach = function(client, bufnr)
    client.resolved_capabilities.document_formatting = false

    local function buf_set_keymap(...)
        vim.api.nvim_buf_set_keymap(bufnr, ...)
    end
    local function buf_set_option(...)
        vim.api.nvim_buf_set_option(bufnr, ...)
    end

    buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

    local opts = { noremap = true, silent = true }
    buf_set_keymap("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts)
    buf_set_keymap("n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts)
    buf_set_keymap("n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>", opts)
    buf_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
    buf_set_keymap("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
    buf_set_keymap("n", "<leader>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
    buf_set_keymap("n", "<leader>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
    buf_set_keymap("n", "<leader>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", opts)
    buf_set_keymap("n", "<leader>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
    buf_set_keymap("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
    buf_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
    buf_set_keymap("n", "<leader>e", "<cmd>lua vim.lsp.diagnostic.open_float()<CR>", opts)
    buf_set_keymap("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
    buf_set_keymap("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
    buf_set_keymap("n", "<leader>l", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)

    if client.resolved_capabilities.document_formatting then
        buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
    elseif client.resolved_capabilities.document_range_formatting then
        buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
    end
    if client.resolved_capabilities.document_highlight then
        vim.api.nvim_exec(
            [[
    hi LspReferenceRead cterm=bold ctermbg=red guibg=LightYellow
    hi LspReferenceText cterm=bold ctermbg=red guibg=LightYellow
    hi LspReferenceWrite cterm=bold ctermbg=red guibg=LightYellow
    augroup lsp_document_highlight
    autocmd! * <buffer>
    autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
    autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
    augroup END
      ]],
            false
        )
    end
end

local servers = {
    -- "bashls",
    -- "cmake",
    -- "cssls",
    "denols",
    -- "dockerls",
    -- "html",
    -- "jsonls",
    -- "ocamllsp",
    "pyright",
    "rnix",
    "rust_analyzer",
    -- "svelte",
    "terraformls",
    -- "vuels"
}
for _, lsp in ipairs(servers) do
    nvim_lsp[lsp].setup({ on_attach = on_attach })
end

-- nvim_lsp.sumneko_lua.setup {
--   on_attach = on_attach,
--   settings = {
--     Lua = {
--       runtime = {
-- 	version  ='LuaJIT',
-- 	path = vim.split(package.path, ';')
--       },
--       diagnostics = {
-- 	globals = {'vim'}
--       },
--       workspace = {
-- 	library = {
-- 	  [vim.fn.expand('$VIMRUNTIME/lua')] = true,
-- 	  [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
-- 	},
--       }
--     }
--   }
-- }
