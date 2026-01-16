return function(luasnip, snippet_opts)
    local s = luasnip.snippet
    local t = luasnip.text_node
    local i = luasnip.insert_node
    local f = luasnip.function_node

    local util = require('util')
    local fmt = require('luasnip.extras.fmt').fmt
    local rep = require('luasnip.extras').rep

    return {
        s('prelude', {
            t({
                'use crate::prelude::*;',
            }),
        }),
        s('bevy_plugin', {
            t({
                'use crate::prelude::*;',
                '',
                'pub struct Plugin;',
                '',
                'impl bevy::app::Plugin for Plugin {',
                '    fn build(&self, app: &mut App) {',
                '        ',
            }),
            i(1),
            t({
                '    }',
                '}',
            }),
        }),

        -- ################
        -- Parameters
        -- ################
        s(
            'bevy_msg_writer',
            fmt('mut msgs: MessageWriter<{}>', {
                i(1, 'MyMessage'),
            })
        ),

        s(
            'bevy_msg_reader',
            fmt('mut msgs: MessageReader<{}>', {
                i(1, 'MyMessage'),
            })
        ),

        s('bevy_commands_param', {
            t('mut commands: Commands, '),
        }),

        s('bevy_asset_server_param', {
            t('asset_server: Res<AssetServer>, '),
        }),

        s(
            'bevy_res_param',
            fmt('{}: Res<{}>, ', {
                f(util.to_snake_case, { 1 }),
                i(1, 'MyResource'),
            })
        ),

        s(
            'bevy_res_mut_param',
            fmt('mut {}: ResMut<{}>, ', {
                f(util.to_snake_case, { 1 }),
                i(1, 'MyResource'),
            })
        ),

        s(
            'bevy_query_param',
            fmt('{}_query: Query<({})>, ', {
                f(util.to_snake_case, { 1 }),
                i(1, 'MyComponent'),
            })
        ),

        s(
            'bevy_query_param',
            fmt('{}_query: Query<({})>, ', {
                f(util.to_snake_case, { 1 }),
                i(1, 'MyComponent'),
            })
        ),

        -- ################
        -- Bevy annotations
        -- ################

        s(
            'bevy_component',
            fmt(
                [[
#[derive(Component, Debug)]
pub struct {} {{
    {}
}}
]],
                {
                    i(1, 'MyComponent'),
                    i(2),
                }
            )
        ),

        s(
            'bevy_msg',
            fmt(
                [[
#[derive(Message, Debug)]
pub struct {} {{
    {}
}}
]],
                {
                    i(1, 'MyMessage'),
                    i(2),
                }
            )
        ),

        s(
            'bevy_resource',
            fmt(
                [[
#[derive(Resource)]
pub struct {} {{
    {}
}}
]],
                {
                    i(1, 'MyResource'),
                    i(2),
                }
            )
        ),

        s(
            'bevy_states',
            fmt(
                [[
#[derive(States, Debug, Clone, Copy, Eq, PartialEq, Hash, Default)]
pub enum {} {{
    #[default]
    {},
}}
]],
                {
                    i(1, 'MyState'),
                    i(2, 'DefaultState'),
                }
            )
        ),

        s(
            'bevy_substates',
            fmt(
                [[
#[derive(SubStates, Clone, Eq, PartialEq, Hash, Debug, Default)]
#[source({} = {}::{})]
pub enum {} {{
    #[default]
    {},
}}
]],
                {
                    i(1, 'MyState'),
                    rep(1),
                    i(2, 'StateValue'),
                    i(3, 'SubState'),
                    i(4, 'SubStateDefaultValue'),
                }
            )
        ),
    }
end
