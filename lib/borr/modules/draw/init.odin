package draw

import "../shader"

import "vendor:OpenGL"

init_state_rect_data :: proc() {
    using OpenGL

    #assert(#exists("../shader/"))

    state := (^Draw_State)(module.state)

    state^.types.rect.verts = {
        0,0, 0,1,
        1,1, 1,1,
        1,0, 0,0
    }

    state^.types.rect.vert = #load("../../../../data/borr/shaders/rect.vert", cstring)
    state^.types.rect.frag = #load("../../../../data/borr/shaders/rect.frag", cstring)

    state^.types.rect.prog = shader.load_program_from_src(&state^.types.rect.vert, &state^.types.rect.frag)

    state^.types.rect.loc_pos  = GetUniformLocation(state^.types.rect.prog, "pos")
    state^.types.rect.loc_col  = GetUniformLocation(state^.types.rect.prog, "col")
    state^.types.rect.loc_size = GetUniformLocation(state^.types.rect.prog, "size")
    state^.types.rect.loc_proj = GetUniformLocation(state^.types.rect.prog, "proj")

    GenVertexArrays(1, &state^.types.rect.vao)
    BindVertexArray(state^.types.rect.vao)

    GenBuffers(1, &state^.types.rect.vbo)
    BindBuffer(ARRAY_BUFFER, state^.types.rect.vbo)
    BufferData(ARRAY_BUFFER, len(state^.types.rect.verts) * size_of(f32), &state^.types.rect.verts, STATIC_DRAW)
    
    VertexAttribPointer(0, 2, FLOAT, FALSE, 2 * size_of(f32), uintptr(0))
    EnableVertexAttribArray(0)

    BindBuffer(ARRAY_BUFFER, 0)
    BindVertexArray(0)
}

unload_state_rect_data :: proc() {
    using OpenGL

    state := (^Draw_State)(module.state)

    shader.delete_program(state^.types.rect.prog)
    DeleteBuffers(1, &state^.types.rect.vbo)
    DeleteVertexArrays(1, &state^.types.rect.vao)
}

