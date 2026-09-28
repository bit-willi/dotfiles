return {
	{
		"nvim-lualine/lualine.nvim",
		opts = function(_, opts)
			-- Re-evaluate the text color on theme changes; every section uses
			-- the terminal background, including mode and location blocks.
			opts.options.theme = function()
				local normal = vim.api.nvim_get_hl(0, { name = "Normal", link = false })
				local fg = normal.fg and string.format("#%06x", normal.fg) or "NONE"
				local theme = {}
				for _, mode in ipairs({ "normal", "insert", "visual", "replace", "command", "terminal", "inactive" }) do
					theme[mode] = {
						a = { fg = fg, bg = "NONE", gui = "bold" },
						b = { fg = fg, bg = "NONE" },
						c = { fg = fg, bg = "NONE" },
					}
				end
				return theme
			end
			opts.options.section_separators = ""
			opts.options.component_separators = ""
		end,
	},
}
