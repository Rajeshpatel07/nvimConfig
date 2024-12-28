return {
  'laytan/cloak.nvim',
  config = function()
    require('cloak').setup {
      enabled = true,
      cloak_character = '*',
      highlight_group = 'Comment',
      cloak_telescope = true,
      try_all_pattens = true,
      patterns = {
        file_pattern = '.env*',
        cloak_pattern = '=.+',
      },
    }
  end,
}
