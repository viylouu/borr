package draw

import "core:fmt"
import "core:strings"

import "vendor:OpenGL"

init :: proc() {
    using OpenGL

    Enable(BLEND)
    BlendFunc(SRC_ALPHA, ONE_MINUS_SRC_ALPHA)

    init_state_rect_data()
}

unload :: proc() {
    using OpenGL

    state := (^Draw_State)(module.state)

    delete_program(state^.types.rect.prog)
    DeleteBuffers(1, &state^.types.rect.vbo)
    DeleteVertexArrays(1, &state^.types.rect.vao)
}


// draw branch todo
// move below to funcs.odin
clear_rgba :: proc(r,g,b,a: u8) {
    using OpenGL
    ClearColor(f32(r)/255., f32(g)/255., f32(b)/255., f32(a)/255.)
    Clear(COLOR_BUFFER_BIT)
}
clear_rgba_arr :: proc(col: [4]u8) { clear_rgba(col.r,col.g,col.b,col.a) }
clear_rgb :: proc(r,g,b: u8) { clear_rgba(r,g,b,255) }
clear_rgb_arr :: proc(col: [3]u8) { clear_rgba(col.r,col.g,col.b,255) }

clear :: proc {
    clear_rgba,
    clear_rgba_arr,
    clear_rgb,
    clear_rgb_arr,
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
