#pragma header
vec2 uv = openfl_TextureCoordv.xy;
vec2 fragCoord = openfl_TextureCoordv*openfl_TextureSize;
vec2 iResolution = openfl_TextureSize;
uniform float iTime;
#define iChannel0 bitmap
#define texture flixel_texture2D
#define fragColor gl_FragColor
#define mainImage main

void mainImage()
{
    vec2 uv = fragCoord / iResolution.xy;
    vec4 texel = texture(iChannel0, uv);
    fragColor = vec4(texel.r * 1., texel.g * 1.15, texel.b * 0.9, 1.0);
}