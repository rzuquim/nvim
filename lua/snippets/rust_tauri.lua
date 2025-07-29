return function(luasnip)
    local s = luasnip.snippet
    local i = luasnip.insert_node

    local fmt = require('luasnip.extras.fmt').fmt

    return {
        s(
            'tauri_rs_file',
            fmt(
                [[
use crate::prelude::*

#[tauri::command]
pub async fn {}() -> Result<String> {{
    return todo!();{}
}}
]],
                {
                    i(1, 'my_tauri_fn'),
                    i(2),
                }
            )
        ),
    }
end
