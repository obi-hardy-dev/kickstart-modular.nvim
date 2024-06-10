return {
  'nvim-java/nvim-java',
  dependencies = {
    'nvim-java/lua-async-await',
    'nvim-java/nvim-java-refactor',
    'nvim-java/nvim-java-core',
    'nvim-java/nvim-java-test',
    'nvim-java/nvim-java-dap',
    'MunifTanjim/nui.nvim',
    'neovim/nvim-lspconfig',
    'mfussenegger/nvim-dap',
    {
      'williamboman/mason.nvim',
      opts = {
        registries = {
          'github:nvim-java/mason-registry',
          'github:mason-org/mason-registry',
        },
      },
    },
  },
  config = function()
    require('java').setup {
      jdk = {
        -- install jdk using mason.nvim
        auto_install = false,
      },
    }

    local dap = require 'dap'
    -- dap.adapters.java = function(callback)
    --
    --   -- FIXME:
    --   -- Here a function needs to trigger the `vscode.java.startDebugSession` LSP command
    --   -- The response to the command must be the `port` used below
    --   callback {
    --     type = 'server',
    --     host = '127.0.0.1',
    --     port = port,
    --   }
    -- end

    local util = require 'jdtls.util'
    dap.adapters.java = function(callback)
      util.execute_command({ command = 'vscode.java.startDebugSession' }, function(err0, port)
        assert(not err0, vim.inspect(err0))
        callback {
          type = 'server',
          host = '127.0.0.1',
          port = port,
        }
      end)
    end
    dap.configurations.java = {
      {
        name = 'Debug Launch (2GB)',
        type = 'java',
        request = 'launch',
        vmArgs = '' .. '-Xmx2g ',
      },
      {
        name = 'Debug Attach (8000)',
        type = 'java',
        request = 'attach',
        hostName = '127.0.0.1',
        port = 8000,
      },
      {
        name = 'Debug Attach (5005)',
        type = 'java',
        request = 'attach',
        hostName = '127.0.0.1',
        port = 5005,
      },
    }
    require('lspconfig').jdtls.setup {

      settings = {
        java = {
          configuration = {
            runtimes = {
              {
                name = 'JavaSE-21',
                path = 'C:/dev/installs/java/jdk-21.0.2',
                default = false,
              },
              {
                name = 'JavaSE-17',
                path = 'C:/dev/installs/java/jdk-17.0.2',
                default = true,
              },
            },
          },
        },
      },
    }
  end,
}

-- vim: ts=2 sts=2 sw=2 et
