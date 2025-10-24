--  Load base editor config to initalize our environment.
--  (NOTE: Must be loaded first to set leader).
require("configs.base")

-- Load rest of the editor configs.
require("configs.mapping")
require("configs.theme")

-- Load editor plugins.
require("configs.lazy")

-- Start plugins
require("lualine").setup()
