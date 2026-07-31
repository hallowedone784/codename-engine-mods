#pragma header

uniform float intensity;
uniform vec3 vignetteColor;

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    // Standard normalized coordinates (0.0 to 1.0)
    vec2 uv = fragCoord.xy / openfl_TextureSize.xy;
    
    // Sample the actual game screen texture
    vec4 texColor = flixel_texture2D(bitmap, openfl_TextureCoordv);
    
    // Calculate vignette mask based on distance from center
    vec2 d = abs(uv - 0.5) * intensity;
    float vig = clamp(1.0 - dot(d, d), 0.0, 1.0);
    
    // Mix the game texture with the vignette color based on the vignette mask
    fragColor = vec4(mix(vignetteColor, texColor.rgb, vig), texColor.a);
}

void main() {
    mainImage(gl_FragColor, openfl_TextureCoordv * openfl_TextureSize);
}