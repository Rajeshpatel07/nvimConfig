return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',
    'MunifTanjim/nui.nvim',
  },
  lazy = false,
  keys = {
    { '<leader>e', ':Neotree toggle<CR>', desc = 'Toggle/Reveal NeoTree', silent = true },
  },

  opts = {
    filesystem = {
      reveal_on_setup = true,
      follow_current_file = {
        enabled = true,
      },
    },
  },
}
