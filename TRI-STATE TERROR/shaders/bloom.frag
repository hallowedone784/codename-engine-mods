#pragma header

uniform float uRadius;

void main() {
	vec2 uv = openfl_TextureCoordv.xy;
	vec2 texel = 1.0 / openfl_TextureSize;

	float r = uRadius;

	vec4 c0 = flixel_texture2D(bitmap, uv);
	vec4 c1 = flixel_texture2D(bitmap, uv + texel * vec2(r, 0.0));
	vec4 c2 = flixel_texture2D(bitmap, uv + texel * vec2(-r, 0.0));
	vec4 c3 = flixel_texture2D(bitmap, uv + texel * vec2(0.0, r));
	vec4 c4 = flixel_texture2D(bitmap, uv + texel * vec2(0.0, -r));
	vec4 c5 = flixel_texture2D(bitmap, uv + texel * vec2(r * 0.7, r * 0.7));
	vec4 c6 = flixel_texture2D(bitmap, uv + texel * vec2(-r * 0.7, r * 0.7));
	vec4 c7 = flixel_texture2D(bitmap, uv + texel * vec2(r * 0.7, -r * 0.7));
	vec4 c8 = flixel_texture2D(bitmap, uv + texel * vec2(-r * 0.7, -r * 0.7));
	vec4 c9 = flixel_texture2D(bitmap, uv + texel * vec2(r * 1.6, 0.0));
	vec4 c10 = flixel_texture2D(bitmap, uv + texel * vec2(-r * 1.6, 0.0));
	vec4 c11 = flixel_texture2D(bitmap, uv + texel * vec2(0.0, r * 1.6));
	vec4 c12 = flixel_texture2D(bitmap, uv + texel * vec2(0.0, -r * 1.6));

	vec3 rgbSum = c0.rgb * c0.a + c1.rgb * c1.a + c2.rgb * c2.a + c3.rgb * c3.a
		+ c4.rgb * c4.a + c5.rgb * c5.a + c6.rgb * c6.a + c7.rgb * c7.a
		+ c8.rgb * c8.a + c9.rgb * c9.a + c10.rgb * c10.a + c11.rgb * c11.a
		+ c12.rgb * c12.a;
	float aSum = c0.a + c1.a + c2.a + c3.a + c4.a + c5.a + c6.a + c7.a
		+ c8.a + c9.a + c10.a + c11.a + c12.a;

	float outA = aSum / 13.0;
	vec3 outRGB = aSum > 0.0001 ? rgbSum / aSum : vec3(0.0);

	gl_FragColor = vec4(outRGB, outA);
}
