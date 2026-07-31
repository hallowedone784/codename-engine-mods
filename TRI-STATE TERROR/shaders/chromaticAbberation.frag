#pragma header

#define iResolution vec3(openfl_TextureSize, 0.)
#define iChannel0 bitmap
#define texture flixel_texture2D
uniform vec4 iMouse;
uniform float intensity;

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = fragCoord/iResolution.xy;

    vec2 separate = (0.05*(uv - 0.5)*(iMouse.xy/iResolution.xy-0.5))*intensity;

    vec3 col = vec3(texture(iChannel0, uv + separate).r, texture(iChannel0, uv).g, texture(iChannel0, uv + -separate).b);

    fragColor = vec4(col.rgb, texture(iChannel0, fragCoord / iResolution.xy).a);
}

void main() {
    mainImage(gl_FragColor, openfl_TextureCoordv*openfl_TextureSize);
}