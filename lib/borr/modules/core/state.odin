package core

import "vendor:glfw"

Core_State :: struct {
    handle: glfw.WindowHandle,
    width: i32,
    height: i32,
    title: cstring,
    gl_major: int,
    gl_minor: int
}

set_state_size :: proc(width, height: i32) {
    state := (^Core_State)(module.state)

    state^.width = width
    state^.height = height
}

set_state_title :: proc(title: cstring) {
    state := (^Core_State)(module.state)

    state^.title = title
}

set_state_gl_version :: proc(major: int, minor: int) {
    state := (^Core_State)(module.state)

    // minimum gl version 3.3
    assert(major * 10 + minor >= 33, "gl version too low! must be atleast 3.3")

    state^.gl_major = major
    state^.gl_minor = minor
}

set_vsync :: proc(state: bool) {
    using glfw

    SwapInterval(state? 1 : 0)
}
