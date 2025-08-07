package core

import mod "../modular"

import "time"

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

    toff := f32(GetTime())
    last: f32

    for !WindowShouldClose(state^.handle) {
        PollEvents()

        time.time = f32(GetTime()) - toff
        time.delta = time.time - last
        last = time.time

        for m in mod.app {
            if m == &module do continue

            for s in m^.systems {
                s.run()
            }
        }

        SwapBuffers(state^.handle)
    }
}
