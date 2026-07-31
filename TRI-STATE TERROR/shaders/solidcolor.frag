#pragma header
uniform vec3 uColor;
void main() {
    vec4 color = flixel_texture2D(bitmap, openfl_TextureCoordv);
    if (color.a > 0.0) {
        gl_FragColor = vec4(uColor, color.a);
    } else {
        gl_FragColor = color;
    }
}