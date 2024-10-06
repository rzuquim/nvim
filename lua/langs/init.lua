-- NOTE: the goal here is to configure everything related to a lang in a single file:
--       the lsp config, treesitter, formatters and extra plugins
--       so in each file you will find props with a 'extra_' prefix
--       this is a custom prop used only on this config, this is not canonical

local ensure_installed = {}
local formatters_by_ft = {}
local linters_by_ft = {}
local lint_conditions = {}
local treesitter_langs = {}
local extra_plugins = {}

local M = {
    bashls = require('langs.bash'),
    clangd = require('langs.clang'),
    cssls = require('langs.css'),
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
}

for lang, settings in pairs(M) do
    if type(settings) ~= 'function' then
        table.insert(ensure_installed, lang)

        if settings.extra_formatters then
            for ft, formattersByFileType in pairs(settings.extra_formatters) do
                formatters_by_ft[ft] = formattersByFileType

                for _, formatter in ipairs(formattersByFileType) do
                    table.insert(ensure_installed, formatter)
                end
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
    end
end

return M
