-- Set the current hour
local hour = tonumber(os.date("%H"))

-- Set colorscheme for day and night
-- + Use dark theme for evening/night
-- + Use light theme for day
if hour > 9 and hour < 17 then
	vim.o.background = "light"
	vim.cmd.colorscheme("lunaperche")
else
	vim.o.background = "dark"
	vim.cmd.colorscheme("lunaperche")
end
