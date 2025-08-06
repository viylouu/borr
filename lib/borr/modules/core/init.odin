package core

import "vendor:glfw"

init_glfw_window_hints :: proc() {
    using glfw

    state := (^Core_State)(module.state)

    WindowHint(RESIZABLE,             FALSE)
    WindowHint(OPENGL_FORWARD_COMPAT, TRUE)
	WindowHint(OPENGL_PROFILE,        OPENGL_CORE_PROFILE)
    WindowHint(CONTEXT_VERSION_MAJOR, cast(i32)state^.gl_major) // fuck you glfw
    WindowHint(CONTEXT_VERSION_MINOR, cast(i32)state^.gl_minor)
    WindowHint(FLOATING,              TRUE)
}

init_glfw_handle :: proc() {
    using glfw

    state := (^Core_State)(module.state)

    state^.handle = CreateWindow(state^.width,state^.height, state^.title, nil,nil)
    assert(state^.handle != nil, "glfw failed to create window")
}
