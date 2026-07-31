#pragma header

uniform float time;
uniform float distortion;
uniform float noiseStrength;

void main()
{
    vec2 uv = openfl_TextureCoordv;

    // Horizontal wiggle
    float wiggle = sin(uv.y * 120.0 + time * 8.0) * 0.003 * distortion;
    uv.x += wiggle;

    // Chromatic aberration
    float offset = 0.002 * distortion;
    vec4 col;
    col.r = texture2D(openfl_Texture, uv + vec2(offset, 0.0)).r;
    col.g = texture2D(openfl_Texture, uv).g;
    col.b = texture2D(openfl_Texture, uv - vec2(offset, 0.0)).b;

    // Scanlines
    float scan = sin(uv.y * 800.0) * 0.04;
    col.rgb -= scan;

    // Noise
    float noise = fract(sin(dot(uv * time, vec2(12.9898, 78.233))) * 43758.5453);
    col.rgb += (noise - 0.5) * noiseStrength;

    gl_FragColor = col;
}
