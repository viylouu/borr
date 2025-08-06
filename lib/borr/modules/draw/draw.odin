package draw

import "../core"

import "core:fmt"
import "core:math/linalg/glsl"
import "core:strings"

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



// non draw branch todo
// goto shader module (shader branch + pr)
// add dependencies to modules (main branch)

compile_program :: proc(shaders: []u32) -> u32 {
    using OpenGL

    prog := CreateProgram()

    for s in shaders do AttachShader(prog, s)
    LinkProgram(prog)

    succ: i32
    GetProgramiv(prog, LINK_STATUS, &succ)
    if !bool(succ) {
        fmt.eprintln("failed to link shader program")
        log: [512]u8
        GetProgramInfoLog(prog, 512, nil, raw_data(&log))
        fmt.eprintln(string(log[:]))
    }

    return prog
}

delete_program :: proc(prog: u32) {
    using OpenGL

    DeleteProgram(prog)
}

load_program_from_src :: proc(vert_src, frag_src: ^cstring) -> u32 {
    using OpenGL

    vsh := load_shader_from_src(VERTEX_SHADER,   vert_src)
    fsh := load_shader_from_src(FRAGMENT_SHADER, frag_src)

    prog := compile_program([]u32{vsh, fsh})

    DeleteShader(vsh)
    DeleteShader(fsh)

    return prog
}

load_shader_from_src :: proc(type: u32, source: ^cstring) -> u32 {
    using OpenGL

    shad := CreateShader(type)
    ShaderSource(shad, 1, source, nil)
    CompileShader(shad)

    succ: i32
    GetShaderiv(shad, COMPILE_STATUS, &succ)
    if !bool(succ) {
        fmt.eprintln("shader compilation failed")
        log: [512]u8
        GetShaderInfoLog(shad, 512, nil, raw_data(&log))
        fmt.eprintln(string(log[:]))
    }

    return shad
}
