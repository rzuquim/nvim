-- NOTE: the goal here is to configure everything related to a lang in a single file:
--       the lsp config, treesitter, formatters and extra plugins
--       so in each file you will find props with a 'extra_' prefix
--       this is a custom prop used only on this config, this is not canonical

local ensure_installed = {}
local formatters_by_ft = {}
local formatters_config = {}
local linters_by_ft = {}
local lint_conditions = {}
local treesitter_langs = {}
local extra_plugins = {}
local extra_dap_config = {}
local extra_snippets = {}

-- NOTE: for config examples see: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
local M = {
    bashls = require('langs.bash'),
    clangd = require('langs.clang'),
    cssls = require('langs.css').css,
    tailwindcss = require('langs.css').tailwind,
    emmet_language_server = require('langs.html').emmet,
    html = require('langs.html').html,
    jdtls = require('langs.java'),
    jsonls = require('langs.json'),
    yamlls = require('langs.yaml'),
    lemminx = require('langs.xml'),
    lua_ls = require('langs.lua'),
    marksman = require('langs.markdown'),
    omnisharp = require('langs.csharp'),
    rust_analyzer = require('langs.rust'),
    taplo = require('langs.toml'),
    vtsls = require('langs.js'),
    sqlls = require('langs.sql'),
    nginx_language_server = require('langs.devops').nginx,
    -- TODO: dockerfile
    -- TODO: gitignore
    -- TODO: sql
    -- TODO: toml
    -- TODO: yaml

    -- exposing resolved resources
    ensure_installed = function()
        return ensure_installed
    end,

    formatters_by_ft = function()
        return formatters_by_ft
    end,

    formatters_config = function()
        return formatters_config
    end,

    linters_by_ft = function()
        return linters_by_ft
    end,

    lint_conditions = function()
        return lint_conditions
    end,

    treesitter = function()
        return treesitter_langs
    end,

    extra_plugins = function()
        return extra_plugins
    end,

    extra_dap_config = function()
        return extra_dap_config
    end,

    extra_snippets = function()
        return extra_snippets
    end,
}

for lang, settings in pairs(M) do
    if type(settings) ~= 'function' then
        table.insert(ensure_installed, lang)

        if settings.extra_formatters then
            for ft, formatters in pairs(settings.extra_formatters) do
                local final_formatters = {}
                for _, formatter in ipairs(formatters) do
                    if type(formatter) == 'string' then
                        table.insert(final_formatters, formatter)
                        table.insert(ensure_installed, formatter)
                    else
                        local curr_formatter = ''
                        for _, item in pairs(formatter) do
                            if type(item) == 'string' then
                                curr_formatter = item
                                table.insert(final_formatters, item)
                                table.insert(ensure_installed, item)
                            else
                                formatters_config[curr_formatter] = item
                            end
                        end
                    end
                end
                formatters_by_ft[ft] = final_formatters
            end
        end

        if settings.extra_linters then
            for ft, linters in pairs(settings.extra_linters) do
                local actual_linters = {}
                local conditions = {}
                for _, linter in ipairs(linters) do
                    if type(linter) == 'function' then
                        table.insert(conditions, linter)
                    else
                        table.insert(actual_linters, linter)
                        table.insert(ensure_installed, linter)
                    end
                end

                if #actual_linters > 0 then
                    linters_by_ft[ft] = actual_linters
                end

                if #conditions > 0 then
                    lint_conditions[ft] = conditions
                end
            end
        end

        if settings.extra_treesitter then
            for _, treesitter in ipairs(settings.extra_treesitter) do
                table.insert(treesitter_langs, treesitter)
            end
        end

        if settings.extra_plugins then
            for _, plugin in pairs(settings.extra_plugins) do
                table.insert(extra_plugins, plugin)
            end
        end

        if settings.extra_dap then
            for dbg_name, dbg_config in pairs(settings.extra_dap) do
                table.insert(ensure_installed, dbg_name)
                table.insert(extra_dap_config, dbg_config)
            end
        end

        if settings.extra_snippets then
            for ft, snippets_fn in pairs(settings.extra_snippets) do
                if not extra_snippets[ft] then
                    extra_snippets[ft] = {}
                end

                table.insert(extra_snippets[ft], snippets_fn)
            end
        end
    end
end

return M
