package core

import mod "../modular"

import "vendor:glfw"

Core_State :: struct {
    handle: glfw.WindowHandle,
    width: i32,
    height: i32,
    title: cstring,
    gl_major: int,
    gl_minor: int
}

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
