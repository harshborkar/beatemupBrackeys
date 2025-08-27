shader_type canvas_item;

uniform float flash : hint_range(0.0, 1.0) = 0.0;
uniform vec4 flash_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);

void fragment() {
    vec4 tex = texture(TEXTURE, UV);

    // keep original alpha
    float a = tex.a;

    // mix original color toward flash_color based on 'flash'
    vec3 rgb = mix(tex.rgb, flash_color.rgb, flash * a);

    COLOR = vec4(rgb, a);
}
