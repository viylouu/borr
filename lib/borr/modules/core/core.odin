package core

import mod "../modular"

import "vendor:glfw"
import gl "vendor:OpenGL"

init :: proc() {
    using glfw

    state := (^Core_State)(module.state)

    assert(bool(Init()), "glfw failed to init")

    init_glfw_window_hints()
    init_glfw_handle()

    MakeContextCurrent(state^.handle)
    SwapInterval(0)

    gl.load_up_to(state^.gl_major, state^.gl_minor, gl_set_proc_address)

    gl.Viewport(0,0, state^.width,state^.height)

    // windows ahh
    SetWindowSize(state^.handle, state^.width + 1, state^.height)
    SetWindowSize(state^.handle, state^.width, state^.height)
}

unload :: proc() {
    using glfw

    DestroyWindow((^Core_State)(module.state)^.handle)

    Terminate()
}

loop :: proc() {
    using glfw

    state := (^Core_State)(module.state)

    for !WindowShouldClose(state^.handle) {
        PollEvents()

        for m in mod.app {
            if m == &module do continue

            for s in m^.systems {
                s.run()
            }
        }

        SwapBuffers(state^.handle)
    }
}



set_size :: proc(width, height: i32) {
    state := (^Core_State)(module.state)

    state^.width = width
    state^.height = height
}

set_title :: proc(title: cstring) {
    state := (^Core_State)(module.state)

    state^.title = title
}

set_gl_version :: proc(major: int, minor: int) {
    state := (^Core_State)(module.state)

    // minimum gl version 3.3
    assert(major * 10 + minor >= 33, "gl version too low! must be atleast 3.3")

    state^.gl_major = major
    state^.gl_minor = minor
}



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
