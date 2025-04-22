local wezterm = require 'wezterm'
return {
	font = wezterm.font 'Fira Code',
	font_size = 12.0,
	harfbuzz_features = { 'ss02' },
	color_scheme = 'Builtin Tango Dark',
	hide_tab_bar_if_only_one_tab = true,
	window_background_opacity = 0.95,
	check_for_updates = false,
}
