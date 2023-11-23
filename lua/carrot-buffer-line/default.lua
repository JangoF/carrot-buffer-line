local build = require("carrot-buffer-line/build")

return {
	config = {
		build_section_left = build.build_section_left,
		build_section_right = build.build_section_right,
		max_buffer_name_length = 40,
	},
}
