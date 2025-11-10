-- Set theme mode by force
local force_light_mode = true
local force_dark_mode = false

-- Set common themes
local light_theme = "catppuccin"
local dark_theme = "sunbather"

if force_light_mode then
	print("light")
	vim.o.background = "light"
	vim.cmd.colorscheme(light_theme)
end

if force_dark_mode then
	print("dark")
	vim.o.background = "dark"
	vim.cmd.colorscheme(dark_theme)
end

-- Set colorscheme for day and night
-- + Use dark theme for evening/night
-- + Use light theme for day
if force_light_mode == false and force_dark_mode == false then
	-- Set the current hour
	local hour = tonumber(os.date("%H"))

	if hour > 9 and hour < 17 then
		vim.o.background = "light"
		vim.cmd.colorscheme(light_theme)
	else
		vim.o.background = "dark"
		vim.cmd.colorscheme(dark_theme)
	end
end
