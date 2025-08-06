package draw

import "../core"

import "core:math/linalg/glsl"

import "vendor:OpenGL"

init :: proc() {
    using OpenGL

    Enable(BLEND)
    BlendFunc(SRC_ALPHA, ONE_MINUS_SRC_ALPHA)

    init_state_rect_data()
}

unload :: proc() {
    unload_state_rect_data()
}

update_proj :: proc() {
    state := (^Draw_State)(module.state)
    core_state := (^core.Core_State)(core.module.state)

    state^.proj = glsl.mat4Ortho3d(0, f32(core_state^.width),f32(core_state^.height), 0, -1000,1000)
}

