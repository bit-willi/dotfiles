local avante = require("avante")

avante.setup({
    provider = "gemini-cli",
    acp_providers = {
        ["gemini-cli"] = {
            command = "gemini",
            args = { "--experimental-acp", "--model", "gemini-2.5-flash" },
        }
    },
    env = {
        NODE_NO_WARNINGS = '1',
        GEMINI_API_KEY = os.getenv("GEMINI_API_KEY"),
    }
})
