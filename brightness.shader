shader_type canvas_item;

uniform float brightness = 2.0;

void fragment() {
    vec3 c = textureLod(SCREEN_TEXTURE, SCREEN_UV, 0.0).rgb;

    c.rgb = mix(vec3(0.0), c.rgb, brightness);

    COLOR.rgb = c;
}