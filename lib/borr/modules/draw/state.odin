package draw

Draw_State :: struct {
    types: struct {
        rect: struct {
            verts: [12]f32,
            vert: cstring,
            frag: cstring,
            vao: u32,
            vbo: u32,
            prog: u32,
            loc_pos: i32,
            loc_size: i32,
            loc_col: i32,
            loc_proj: i32
        }
    },
    proj: matrix[4,4]f32
}
