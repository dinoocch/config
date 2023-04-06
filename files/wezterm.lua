local wezterm = require("wezterm")
local config = wezterm.config_builder()
config.font = wezterm.font("Comic Code Ligatures")
config.color_scheme = "Catppuccin Frappe"

return config
