package draw

import "vendor:OpenGL"

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


rect_rgba_f32 :: proc(x,y,w,h: f32, r,g,b,a: u8) {
    using OpenGL

    state := (^Draw_State)(module.state)

    UseProgram(state^.types.rect.prog)
    BindVertexArray(state^.types.rect.vao)

    UniformMatrix4fv(state^.types.rect.loc_proj, 1, false, transmute([^]f32)&state^.proj)
    Uniform2f(state^.types.rect.loc_pos,  x,y)
    Uniform2f(state^.types.rect.loc_size, w,h)
    Uniform4f(state^.types.rect.loc_col, f32(r)/255., f32(g)/255., f32(b)/255., f32(a)/255.)

    DrawArrays(TRIANGLES, 0,6)

    BindVertexArray(0)
    UseProgram(0)
}
rect_rgba_arr_f32 :: proc(x,y,w,h: f32, col: [4]u8) { rect_rgba_f32(x,y,w,h, col.r,col.g,col.b,col.a) }
rect_rgb_f32 :: proc(x,y,w,h: f32, r,g,b: u8) { rect_rgba_f32(x,y,w,h, r,g,b,255) }
rect_rgb_arr_f32 :: proc(x,y,w,h: f32, col: [3]u8) { rect_rgba_f32(x,y,w,h, col.r,col.g,col.b,255) }

frect :: proc {
    rect_rgba_f32,
    rect_rgba_arr_f32,
    rect_rgb_f32,
    rect_rgb_arr_f32,
}


rect_rgba_i32 :: proc(x,y,w,h: i32, r,g,b,a: u8) { rect_rgba_f32(f32(x),f32(y),f32(w),f32(h), r,g,b,a) }
rect_rgba_arr_i32 :: proc(x,y,w,h: i32, col: [4]u8) { rect_rgba_i32(x,y,w,h, col.r,col.g,col.b,col.a) }
rect_rgb_i32 :: proc(x,y,w,h: i32, r,g,b: u8) { rect_rgba_i32(x,y,w,h, r,g,b,255) }
rect_rgb_arr_i32 :: proc(x,y,w,h: i32, col: [3]u8) { rect_rgba_i32(x,y,w,h, col.r,col.g,col.b,255) }

rect :: proc {
    rect_rgba_i32,
    rect_rgba_arr_i32,
    rect_rgb_i32,
    rect_rgb_arr_i32,
}

