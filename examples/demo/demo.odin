package demo

import mod "../../lib/borr/modules/modular"
import "../../lib/borr/modules/core"
import "../../lib/borr/modules/draw"

main :: proc() {
    mod.app = {
        &core.module,
        &draw.module,
        &module
    }

    core.set_size(800,600)
    core.set_title("demo")
    core.set_gl_version(3,3)

    mod.start()
}

module := mod.Module{
    name = "demo",
    init = nil,
    unload = nil,
    systems = {
        &{ name = "render",
            run = loop
        }
    },
    state = nil
}

loop :: proc() {
    draw.clear(255,255,255)

    draw.rect(64,64,64,64, 255,0,0)
}
