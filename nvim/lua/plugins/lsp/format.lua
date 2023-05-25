local M = {}

local util = require('vim.lsp.util')

local make_autocmd_format_callback = function(client, bufnr)
  return function(args)
    local wait_ms = args.data
    local params = util.make_formatting_params({})
    local result, err = client.request_sync(
      "textDocument/formatting", params, wait_ms, bufnr)
    if result and result.result then
      local enc = (client or {}).offset_encoding or "utf-16"
      util.apply_text_edits(result.result, bufnr, enc)
    elseif err then
      vim.notify("make_autocmd_format_callback: " .. err, vim.log.levels.WARN)
    end
  end
end

local lspFmtGrp = vim.api.nvim_create_augroup("LspFormatting", {})

function M.autocmd_format_callback(client, bufnr)
  if client.supports_method("textDocument/formatting") then
    vim.api.nvim_clear_autocmds({ group = lspFmtGrp, buffer = bufnr })
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = lspFmtGrp,
      buffer = bufnr,
      callback = make_autocmd_format_callback(client, bufnr),
    })
  end
end

local make_go_imports_callback = function(client, bufnr)
  return function(args)
    local wait_ms = args.data
    local params = util.make_range_params()
    params.context = {only = {"source.organizeImports"}}
    local result, err =
      client.request_sync("textDocument/codeAction", params, wait_ms, bufnr)
    if result and result.result then
      for _, res in pairs(result or {}) do
        for _, r in pairs(res or {}) do
          if r.edit then
            local enc = (client or {}).offset_encoding or "utf-16"
            util.apply_workspace_edit(r.edit, enc)
          end
        end
      end
    elseif err then
      vim.notify("make_go_imports_callback: " .. err, vim.log.levels.WARN)
    end
  end
end

local make_go_save_callback = function(client, bufnr)
  return function(args)
    make_go_imports_callback(client, bufnr)(args)
    make_autocmd_format_callback(client, bufnr)(args)
  end
end

local lspGoSaveUtils = vim.api.nvim_create_augroup("LspGoImports", {})

function M.attach_go_save_utils(client, bufnr)
  if client.supports_method("textDocument/formatting") and
    client.supports_method("textDocument/codeAction") then
    vim.api.nvim_clear_autocmds({ group = lspGoSaveUtils, buffer = bufnr })
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = lspGoSaveUtils,
      buffer = bufnr,
      callback = make_go_save_callback(client, bufnr)
    })
  end
end

return M
