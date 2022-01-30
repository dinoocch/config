local lsp = require('feline.providers.lsp')
local gps = require("nvim-gps")


local force_inactive = {
  filetypes = {},
  buftypes = {},
  bufnames = {}
}

local components = {
  active = {{}, {}},
  inactive = {{}, {}},
}

-- from gruvbox.nvim; TODO: figure out how to just reference colors
local colors = {
    bg = "#32302f",
    dark0_hard = "#1d2021",
    dark0 = "#282828",
    dark0_soft = "#32302f",
    dark1 = "#3c3836",
    dark2 = "#504945",
    dark3 = "#665c54",
    dark4 = "#7c6f64",
    light0_hard = "#f9f5d7",
    light0 = "#fbf1c7",
    light0_soft = "#f2e5bc",
    light1 = "#ebdbb2",
    light2 = "#d5c4a1",
    light3 = "#bdae93",
    light4 = "#a89984",
    bright_red = "#fb4934",
    bright_green = "#b8bb26",
    bright_yellow = "#fabd2f",
    bright_blue = "#83a598",
    bright_purple = "#d3869b",
    bright_aqua = "#8ec07c",
    bright_orange = "#fe8019",
    neutral_red = "#cc241d",
    neutral_green = "#98971a",
    neutral_yellow = "#d79921",
    neutral_blue = "#458588",
    neutral_purple = "#b16286",
    neutral_aqua = "#689d6a",
    neutral_orange = "#d65d0e",
    faded_red = "#9d0006",
    faded_green = "#79740e",
    faded_yellow = "#b57614",
    faded_blue = "#076678",
    faded_purple = "#8f3f71",
    faded_aqua = "#427b58",
    faded_orange = "#af3a03",
    gray = "#928374",
}

local vi_mode_colors = {
  NORMAL = 'neutral_blue',
  OP = 'neutral_green',
  INSERT = 'neutral_purple',
  VISUAL = 'neutral_orange',
  LINES = 'neutrarl_orange',
  BLOCK = 'neutrarl_orange',
  REPLACE = 'faded_red',
  ['V-REPLACE'] = 'faded_purple',

  ENTER = 'neutral_aqua',
  MORE = 'neutral_aqua',
  SELECT = 'faded_orange',
  COMMAND = 'faded_aqua',
  SHELL = 'neutral_aqua',
  TERM = 'neutral_aqua',
  NONE = 'bright_yellow'
}

force_inactive.filetypes = {
  'NvimTree',
  'packer',
  'fugitive',
  'fugitiveblame'
}

force_inactive.buftypes = {
  'terminal'
}

table.insert(components.active[1], {
  provider = 'scroll_bar',
  hl = {
    fg = 'faded_yellow',
    bg = 'bg',
  },
  right_sep = ' ',
})

table.insert(components.active[1], {
  provider = 'vi_mode',
  hl = function()
    return {
      name = require('feline.providers.vi_mode').get_mode_highlight_name(),
      fg = require('feline.providers.vi_mode').get_mode_color(),
      style = 'bold'
    }
  end,
  icon = '',
  right_sep = ' ',
})

table.insert(components.active[1], {
  provider = 'file_info',
  opts = {
    type = 'unique',
  },
  hl = {
      fg = 'white',
      bg = 'bg',
      style = 'bold'
  },
  right_sep = ' ',
})

table.insert(components.active[1], {
  provider = function() return gps.get_location() end,
  enabled = function() return gps.is_available() end,
  hl = {
    fg = 'white',
    bg = 'bg',
    style = 'bold'
  },
  left_sep = {
    str = '> ',
    hl = {
      fg = 'white',
      bg = 'bg',

      style = 'bold'
    },
  }
})

-- git
table.insert(components.active[2], {
  provider = 'git_branch',
  hl = {
    fg = 'bright_purple',
    bg = 'bg',
    style = 'bold'
  }
})
table.insert(components.active[2], {
  provider = 'git_diff_added',
  hl = {
    fg = 'bright_green',
    bg = 'bg',
    style = 'bold'
  }
})

table.insert(components.active[2], {
  provider = 'git_diff_changed',
  hl = {
    fg = 'bright_orange',
    bg = 'bg',
    style = 'bold'
  }
})
table.insert(components.active[2], {
  provider = 'git_diff_removed',
  hl = {
    fg = 'bright_red',
    bg = 'bg',
    style = 'bold'
  },
})

-- lsp
table.insert(components.active[2], {
  provider = 'lsp_client_names',
  hl = {
    fg = 'bright_blue',
    bg = 'bg',
    style = 'bold'
  },
  right_sep = ' '
})
table.insert(components.active[2], {
  provider = 'diagnostic_errors',
  enabled = function() return lsp.diagnostics_exist(0) end,
  hl = {
    fg = 'faded_red',
    style = 'bold'
  }
})
table.insert(components.active[2], {
  provider = 'diagnostic_warnings',
  enabled = function() return lsp.diagnostics_exist(1) end,
  hl = {
    fg = 'faded_yellow',
    style = 'bold'
  }
})
table.insert(components.active[2], {
  provider = 'diagnostic_hints',
  enabled = function() return lsp.diagnostics_exist(3) end,
  hl = {
    fg = 'faded_aqua',
    style = 'bold'
  }
})
table.insert(components.active[2], {
  provider = 'diagnostic_info',
  enabled = function() return lsp.diagnostics_exist(2) end,
  hl = {
    fg = 'light0',
    style = 'bold'
  },
})

table.insert(components.active[2], {
  provider = 'file_type',
  left_sep = 'vertical_bar',
  right_sep = ' '
})

table.insert(components.active[2], {
  provider = 'position',
  right_sep = ' '
})

require('feline').setup({
  colors = colors,
  default_bg = bg,
  default_fg = fg,
  vi_mode_colors = vi_mode_colors,
  components = components,
  force_inactive = force_inactive,

})
