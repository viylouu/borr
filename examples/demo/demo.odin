package demo

import mod "../../lib/borr/modules/modular"
import "../../lib/borr/modules/core"
import "../../lib/borr/modules/core/time"
import "../../lib/borr/modules/draw"
import "../../lib/borr/modules/shader"

import "core:fmt"

main :: proc() {
    mod.app = {
        &core.module,
        &draw.module,
        &shader.module,
        &module
    }

    core.set_state_size(800,600)
    core.set_state_title("demo")
    core.set_state_gl_version(3,3)

    mod.start()
}

module := mod.Module{
    name = "demo",
    init = init,
    systems = {
        &{ name = "render",
            run = loop
        }
    }
}

init :: proc() {
    core.set_vsync(true)
}

loop :: proc() {
    draw.clear(255,255,255)

    draw.rect(64,64,64,64, 255,0,0)
}
