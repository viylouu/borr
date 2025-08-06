package draw

import mod "../modular"

module := mod.Module{
    name = "draw",
    init = init,
    unload = unload,
    systems = {},
    state = &Draw_State{}
}
