local wezterm = require 'wezterm'
return {
	font = wezterm.font 'Monaspace Neon NF',
	font_size = 12.0,
	harfbuzz_features = { 'ss02' },
	color_scheme = 'Catppuccin Mocha',
	hide_tab_bar_if_only_one_tab = true,
	window_background_opacity = 0.95,
	check_for_updates = false,
}
