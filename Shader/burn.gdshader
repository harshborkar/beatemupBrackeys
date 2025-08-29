shader_type canvas_item;

// Keep dissolve_value as export uniform
uniform float dissolve_value : hint_range(0,1.1);

// Hardcoded noise texture settings (Simplex, Seed 9, Frequency 9.0)
float simplex_noise(vec3 uv) {
    // Simplex noise implementation with seed 9 and frequency 9.0
    vec3 i = floor(uv + dot(uv, vec3(0.333333)) );
    vec3 x = uv - i + dot(i, vec3(0.166666));
    vec3 g = step(x.yzx, x);
    vec3 l = 1.0 - g;
    vec3 i1 = min(g, l.zxy);
    vec3 i2 = max(g, l.zxy);
    vec3 x1 = x - i1 + 0.166666;
    vec3 x2 = x - i2 + 0.333333;
    vec3 x3 = x - 0.5;
    
    // Apply seed (9) and frequency (9.0)
    vec3 p = fract((i + vec3(9.0)) * 0.0243902439) * 9.0;
    vec4 v = max(0.5 - vec4(dot(x,x), dot(x1,x1), dot(x2,x2), dot(x3,x3)), 0.0);
    vec4 d = vec4(dot(p, x), dot(p + i1, x1), dot(p + i2, x2), dot(p + 1.0, x3));
    
    return dot(v*v*v*v, d) * 52.0;
}

void fragment() {
    vec4 main_texture = texture(TEXTURE, UV);
    
    // Hardcoded values from your settings
    float burn_size = 0.26;
    vec4 burn_color = vec4(1.0, 0.5, 0.0, 1.0);  // Orange burn color
    
    // Generate noise with your exact settings
    vec3 noise_uv = vec3(UV * 512.0 / 512.0 * 9.0, 0.0);
    float noise = (simplex_noise(noise_uv) + 1.0) * 0.5;  // Convert from [-1,1] to [0,1]
    noise = clamp(noise, 0.0, 1.0);
    
    // FIX: CORRECTED BURN EFFECT LOGIC
    // The burn effect should appear at the edge between dissolved and non-dissolved areas
    
    // Calculate where the dissolve happens (noise close to dissolve_value)
    float dissolve_edge = smoothstep(dissolve_value - burn_size, dissolve_value + burn_size, noise);
    
    // Calculate the burn color intensity (strongest at the exact edge)
    float burn_intensity = 1.0 - abs(noise - dissolve_value) / burn_size;
    burn_intensity = clamp(burn_intensity, 0.0, 1.0);
    
    // Main visibility - show where noise is greater than dissolve_value
    float visibility = step(dissolve_value, noise);
    
    COLOR.a = main_texture.a * visibility;
    
    // Apply burn color at the edge, mix with original texture
    if (burn_intensity > 0.0) {
        COLOR.rgb = mix(main_texture.rgb, burn_color.rgb, burn_intensity);
    } else {
        COLOR.rgb = main_texture.rgb;
    }
    
    // Only vanish when dissolve_value is very close to 0.0
    if (dissolve_value <= 0.001) {
        COLOR.a = 0.0;
    }
}