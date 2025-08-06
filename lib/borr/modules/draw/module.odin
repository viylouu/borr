package draw

import mod "../modular"

module := mod.Module{
    name = "draw",
    dependencies = { "core" },
    init = init,
    unload = unload,
    systems = {
        &{ name = "proj",
            run = update_proj
        }
    },
    state = &Draw_State{}
}
