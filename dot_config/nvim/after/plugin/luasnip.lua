local ls = require("luasnip")
-- some shorthands...
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local l = require("luasnip.extras").lambda
local rep = require("luasnip.extras").rep
local p = require("luasnip.extras").partial
local m = require("luasnip.extras").match
local n = require("luasnip.extras").nonempty
local dl = require("luasnip.extras").dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local types = require("luasnip.util.types")
local conds = require("luasnip.extras.conditions")
local conds_expand = require("luasnip.extras.conditions.expand")

ls.setup({
	keep_roots = true,
	link_roots = true,
	link_children = true,

	update_events = "TextChanged,TextChangedI",
	delete_check_events = "TextChanged",
	ext_opts = {
		[types.choiceNode] = {
			active = {
				virt_text = { { "choiceNode", "Comment" } },
			},
		},
	},
	ext_base_prio = 300,
	ext_prio_increase = 1,
	enable_autosnippets = true,
	store_selection_keys = "<Tab>",
	ft_func = function()
		return vim.split(vim.bo.filetype, ".", true)
	end,
})

local function copy(args)
	return args[1]
end

local rec_ls
rec_ls = function()
	return sn(
		nil,
		c(1, {
			t(""),
			sn(nil, { t({ "", "\t\\item " }), i(1), d(2, rec_ls, {}) }),
		})
	)
end

-- Make sure to not pass an invalid command, as io.popen() may write over nvim-text.
local function bash(_, _, command)
	local file = io.popen(command, "r")
	local res = {}
	for line in file:lines() do
		table.insert(res, line)
	end
	return res
end

-- Returns a snippet_node wrapped around an insertNode whose initial
-- text value is set to the current date in the desired format.
local date_input = function(args, snip, old_state, fmt)
	local fmt = fmt or "%Y-%m-%d"
	return sn(nil, i(1, os.date(fmt)))
end

-- Dinamicaly build php doc block
local function phpdocsnip(args, _, old_state)
    local nodes = {
        t({ "/**", " * " }),
        i(1, "A short description"),
        t({ "", "" }),
        t({ " *", "" }),
    }

    -- Table to store dynamic nodes for each parameter and return type.
    local param_nodes = {}

    -- Retain user input from previous snippet expansions if old_state is available.
    if old_state then
        nodes[2] = i(1, old_state.descr:get_text())
    end
    param_nodes.descr = nodes[2]

    -- Handle parameters and types.
    local insert = 2
    for _, arg in ipairs(vim.split(args[2][1], ", ", true)) do
        local arg_parts = vim.split(arg, " ")
        local arg_type = arg_parts[1] or "mixed"
        local arg_name = arg_parts[2] or arg_parts[1]

        if arg_name then
            local inode
            if old_state and old_state[arg_name] then
                inode = i(insert, old_state["arg" .. arg_name]:get_text())
            else
                inode = i(insert)
            end

            -- Generate the @param docblock for each argument.
            vim.list_extend(
                nodes,
                { t({ " * @param " .. arg_type .. " " .. arg_name }), inode, t({ "", "" }) }
            )
            param_nodes["arg" .. arg_name] = inode
            insert = insert + 1
        end
    end

    -- Handle return type.
    local return_type = args[1][1] or "void"
    if return_type ~= "void" then
        local inode
        if old_state and old_state.ret then
            inode = i(insert, old_state.ret:get_text())
        else
            inode = i(insert)
        end

        -- Generate the @return docblock.
        vim.list_extend(
            nodes,
            { t({ " * ", " * @return " .. return_type .. " " }), inode, t({ "", "" }) }
        )
        param_nodes.ret = inode
        insert = insert + 1
    end

    -- Close the docblock.
    vim.list_extend(nodes, { t({ " */" }) })

    -- Create the snippet.
    local snip = sn(nil, nodes)
    snip.old_state = param_nodes
    return snip
end

ls.add_snippets("norg", {
        -- Create a new day into journal
	s(
		"day",
		fmt("** {time}\n - TODOs\n -- {}", {
                    i(2, "Task"),
                    time = date_input()
		})
	),
        -- Create a new time box into journal
	s("timebox", {
		t("- "),
		d(1, date_input, {}, { user_args = { "%H" } }),
                t(":"),
		d(2, date_input, {}, { user_args = { "%M" } }),
                t(" - xx/10:"),
                t({"\t", " -- "}),
                i(3, "TASK"),
	}),
}, {
	key = "norg",
})

-- Add snippets for PHP functions.
ls.add_snippets("php", {
    s("fn", {
        d(5, phpdocsnip, { 4, 3 }), -- Dynamically generates the docblock.
        t({ "", "" }),
        c(1, {
            t(""),
            t("public "),
            t("private "),
            t("protected ")
        }),
        t("function "),
        i(2, "functionName"), -- Placeholder for function name.
        t("("),
        i(3),                 -- Placeholder for function parameters.
        t("): "),
        -- Add the return type handling here:
        c(4, {
            i(nil, "mixed"),  -- Editable placeholder for custom return type.
            t("void"),         -- Default return type (you can change it based on context).
            t("int"),
            t("string"),
            t("bool"),
            t("array"),
        }),
        t({ "", "{", "\t" }),
        i(0),
        t({ "", "}" }),
    }),
}, {
    key = "php",
})

require("luasnip.loaders.from_vscode").lazy_load()
ls.filetype_extend("php", { "phpdoc" })

vim.keymap.set({"i"}, "<C-k>", function() ls.expand() end, {silent = true})
vim.keymap.set({"i", "s"}, "<C-l>", function() ls.jump( 1) end, {silent = true})
vim.keymap.set({"i", "s"}, "<C-j>", function() ls.jump(-1) end, {silent = true})
vim.keymap.set({"i", "s"}, "<C-e>", function()
	if ls.choice_active() then
		ls.change_choice(1)
	end
end, {silent = true})
vim.keymap.set("n", "<leader><leader>s", "<cmd>source /home/bit/.config/nvim/after/plugin/luasnip.lua<CR>")

