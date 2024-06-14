return {
  {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = { 'nvim-lua/plenary.nvim', 'nvim-telescope/telescope.nvim' },
    config = function()
      local harpoon = require 'harpoon'

      require('telescope').load_extension 'harpoon'
      -- REQUIRED
      harpoon:setup()
      -- REQUIRED

      vim.keymap.set('n', '<leader>a', function()
        harpoon:list():add()
      end, { desc = '[A]dd to harpoon' })

      vim.keymap.set('n', '<C-h>', function()
        harpoon:list():select(1)
      end, { desc = 'Open buffer 1' })
      vim.keymap.set('n', '<C-j>', function()
        harpoon:list():select(2)
      end, { desc = 'Open buffer 2' })
      vim.keymap.set('n', '<C-k>', function()
        harpoon:list():select(3)
      end, { desc = 'Open buffer 3' })
      vim.keymap.set('n', '<C-l>', function()
        harpoon:list():select(4)
      end, { desc = 'Open buffer 4' })

      vim.keymap.set('n', '<leader>r', function()
        harpoon:list():remove()
      end, { desc = '[R]emove current from harpoon' })

      -- Toggle previous & next buffers stored within Harpoon list
      vim.keymap.set('n', '<C-p>', function()
        harpoon:list():prev()
      end, { desc = 'Go to [P]revious buffer' })
      vim.keymap.set('n', '<C-n>', function()
        harpoon:list():next()
      end, { desc = 'Go to [N]ext buffer' })

      local conf = require('telescope.config').values
      local function toggle_telescope(harpoon_files)
        local file_paths = {}
        for _, item in ipairs(harpoon_files.items) do
          table.insert(file_paths, item.value)
        end

        local finder = function()
          local paths = {}
          for _, item in ipairs(harpoon_files.items) do
            table.insert(paths, item.value)
          end

          return require('telescope.finders').new_table {
            results = paths,
          }
        end

        require('telescope.pickers')
          .new({}, {
            prompt_title = 'Harpoon',
            finder = require('telescope.finders').new_table {
              results = file_paths,
            },
            previewer = conf.file_previewer {},
            sorter = conf.generic_sorter {},
            attach_mappings = function(prompt_bufnr, map)
              map('i', '<C-d>', function()
                local state = require 'telescope.actions.state'
                local selected_entry = state.get_selected_entry()
                local current_picker = state.get_current_picker(prompt_bufnr)

                table.remove(harpoon_files.items, selected_entry.index)
                current_picker:refresh(finder())
              end)
              return true
            end,
          })
          :find()
      end

      vim.keymap.set('n', '<C-e>', function()
        toggle_telescope(harpoon:list())
      end, { desc = 'Open harpoon window' })
    end,
  },
}
