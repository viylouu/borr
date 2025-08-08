package texture

Texture :: struct {
    glid: u32,
    fbo: u32,
    width, height: i32,
    filter: Filter
}

Filter :: enum {
    NEAREST,
    BILINEAR
}
