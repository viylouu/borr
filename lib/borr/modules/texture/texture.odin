package texture

import "vendor:OpenGL"
import "vendor:stb/image"

create :: proc(width,height: i32) -> ^Texture {
    using OpenGL

    fbo: u32
    GenFramebuffers(1, &fbo)
    BindFramebuffer(FRAMEBUFFER, fbo)

    glid: u32
    GenTextures(1, &glid)
    BindTexture(TEXTURE_2D, glid)

    TexParameteri(TEXTURE_2D, TEXTURE_WRAP_S, REPEAT)
    TexParameteri(TEXTURE_2D, TEXTURE_WRAP_T, REPEAT)
    TexParameteri(TEXTURE_2D, TEXTURE_MIN_FILTER, NEAREST)
    TexParameteri(TEXTURE_2D, TEXTURE_MAG_FILTER, NEAREST)

    TexImage2D(TEXTURE_2D, 0, RGBA, width,height, 0, RGBA, UNSIGNED_BYTE, nil)

    BindTexture(TEXTURE_2D, 0)

    FramebufferTexture2D(FRAMEBUFFER, COLOR_ATTACHMENT0, TEXTURE_2D, glid, 0)
    assert(CheckFramebufferStatus(FRAMEBUFFER) == FRAMEBUFFER_COMPLETE, "framebuffer is not complete")

    BindFramebuffer(FRAMEBUFFER, 0)

    tex := new(Texture)
    tex^.glid = glid
    tex^.fbo = fbo
    tex^.width = width
    tex^.height = height
    tex^.filter = .NEAREST

    return tex
}

load_from_data :: proc(data: []u8) -> ^Texture {
    w,h,channels: i32
    img_data := image.load_from_memory(raw_data(data), cast(i32)len(data), &w,&h,&channels, 4)
    assert(img_data != nil, "failed to load texture")
    assert(channels != 4, "texture does not have exactly 4 channels")

    defer image.image_free(img_data)

    using OpenGL

    fbo: u32
    GenFramebuffers(1, &fbo)
    BindFramebuffer(FRAMEBUFFER, fbo)

    glid: u32
    GenTextures(1, &glid)
    BindTexture(TEXTURE_2D, glid)

    TexParameteri(TEXTURE_2D, TEXTURE_WRAP_S, REPEAT)
    TexParameteri(TEXTURE_2D, TEXTURE_WRAP_T, REPEAT)
    TexParameteri(TEXTURE_2D, TEXTURE_MIN_FILTER, NEAREST)
    TexParameteri(TEXTURE_2D, TEXTURE_MAG_FILTER, NEAREST)

    TexImage2D(TEXTURE_2D, 0, RGBA, w,h, 0, RGBA, UNSIGNED_BYTE, img_data)

    BindTexture(TEXTURE_2D, 0)

    FramebufferTexture2D(FRAMEBUFFER, COLOR_ATTACHMENT0, TEXTURE_2D, glid, 0)
    assert(CheckFramebufferStatus(FRAMEBUFFER) == FRAMEBUFFER_COMPLETE, "framebuffer is not complete")

    BindFramebuffer(FRAMEBUFFER, 0)

    tex := new(Texture)
    tex^.glid = glid
    tex^.fbo = fbo
    tex^.width = w
    tex^.height = h
    tex^.filter = .NEAREST

    return tex
}
