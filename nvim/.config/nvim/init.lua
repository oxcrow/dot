--  Load base editor config to initalize our environment.
--  (NOTE: Must be loaded first to set leader).
require("configs.base")

-- Load editor plugins.
require("configs.lazy")
-- Load rest of the editor configs.
require("configs.autocmd")
require("configs.mapping")
require("configs.theme")

-- Start plugins
require("lualine").setup()
