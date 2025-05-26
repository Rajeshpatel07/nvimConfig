-- ~/.config/nvim/lua/custom/linting.lua
return {
  {
    'mfussenegger/nvim-lint',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local lint = require 'lint'

      -- Configure Biome linter
      lint.linters.biome = {
        cmd = 'biome',
        args = {
          'lint',
          '--stdin-file-path',
          '%:p', -- Use full file path
          '--json',
        },
        stdin = true,
        stream = 'stdout',
        ignore_exitcode = true,
        parser = function(output)
          if output == '' then
            return {}
          end
          local ok, data = pcall(vim.json.decode, output)
          if not ok then
            return {}
          end

          local diagnostics = {}
          if data.diagnostics then
            for _, diag in ipairs(data.diagnostics) do
              table.insert(diagnostics, {
                lnum = math.max((diag.location.line or 1) - 1, 0),
                col = math.max((diag.location.column or 1) - 1, 0),
                end_lnum = math.max((diag.location.end_line or diag.location.line or 1) - 1, 0),
                end_col = math.max((diag.location.end_column or diag.location.column or 1) - 1, 0),
                message = ('%s [%s]'):format(diag.message, diag.code),
                severity = diag.severity == 'error' and vim.diagnostic.severity.ERROR or vim.diagnostic.severity.WARN,
                source = 'biome',
              })
            end
          end
          return diagnostics
        end,
      }

      -- Filetype associations
      lint.linters_by_ft = {
        javascript = { 'biome' },
        typescript = { 'biome' },
        javascriptreact = { 'biome' },
        typescriptreact = { 'biome' },
      }

      -- Disable conflicting LSP diagnostics
      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client and client.name == 'tsserver' then
            client.server_capabilities.diagnosticProvider = false
          end
        end,
      })

      -- Diagnostic display config
      vim.diagnostic.config {
        virtual_text = {
          source = 'if_many',
          prefix = '●',
        },
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
      }

      -- Auto-lint on save and text change
      vim.api.nvim_create_autocmd({ 'BufWritePost', 'TextChanged' }, {
        callback = function()
          require('lint').try_lint()
        end,
      })
    end,
  },
}
