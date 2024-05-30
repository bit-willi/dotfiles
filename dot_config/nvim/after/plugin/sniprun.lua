require("sniprun").setup({
    interpreter_options = {
        Generic = {
            error_truncate="long",
            php = {
                supported_filetypes = {"php"},
                extension = ".php",
                interpreter = "php",
                compiler = "",
            },
        }
    }
})
