function ColorItBaby(color) 
	-- color = color or "rose-pine"
	color = color or "melange"
	-- color = color or "gruber-darker"
	vim.cmd.colorscheme(color)

	vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })

	vim.api.nvim_set_hl(0, "Visual", { bg = "#727272" })
end

ColorItBaby()
