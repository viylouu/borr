package core

import mod "../modular"

module := mod.Module{
    name = "core",
    init = init,
    unload = unload,
    systems = {
        &{ name = "update",
            tags = { "caller" },
            run = loop
        }
    },
    state = &Core_State{}
}
