#version 330 core

layout(location = 0) in vec2 vert;

uniform mat4 proj;
uniform vec2 pos;
uniform vec2 size;

void main() {
    gl_Position = proj * vec4(vert * size + pos, 0,1);
}
