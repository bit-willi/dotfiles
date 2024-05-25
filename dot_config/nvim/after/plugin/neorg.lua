require("neorg").setup({
    load = {
        ["core.defaults"] = {},
        ["core.concealer"] = {},
        ["core.dirman"] = {
            config = {
                workspaces = {
                    notes = "~/.journal",
                },
                default_workspace = "notes",
            },
        },
        ["core.export"] = {},
        ["core.export.markdown"] = {
            config = {
                public = {
                    export_dir = "~/.journal/posts",
                },
                extensions = "all",
                export_dir = "~/Documents/codes/personal/blog/_posts"
            }
        }
    },
})
