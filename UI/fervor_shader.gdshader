shader_type canvas_item;

// modified from xxidbr9's Balatro Fire Shader on godotshaders.com

uniform sampler2D noise_tex : hint_default_white;
uniform vec4 bottom_color : source_color = vec4(0.0, 0.7, 1.0, 1.0);
uniform vec4 middle_color : source_color = vec4(1.0, 0.5, 0.0, 1.0);
uniform vec4 top_color : source_color = vec4(1.0, 0.03, 0.001, 1.0);
uniform vec2 fire_speed = vec2(0.0, 2.0);
uniform float fire_aperture : hint_range(0.0, 3.0) = 1.0;
uniform float pixel_amount : hint_range(10.0, 80.0, 5.0) = 40.0;
uniform float fire_height : hint_range(0.0, 1.0, 0.01) = 1.0;
uniform float box_height : hint_range(0.0, 1.0, 0.01) = 0.3;

vec4 tri_color_mix(vec4 color1, vec4 color2, vec4 color3, float pos) {
    pos = clamp(pos, 0.0, 2.0);
    if (pos < 1.5) {
        return mix(color1, color2, pos * 2.0);
    } else {
        return mix(color2, color3, (pos - 0.5) * 2.0);
    }
}

void fragment() {
	vec2 base_uv = UV;
	
	float alt_fire_height = (fire_height * (1.0 - box_height)) + box_height;
	base_uv = vec2(round(UV.x * pixel_amount) / pixel_amount, round(UV.y * pixel_amount * 2.0) / pixel_amount);
	
    // Create two layers of noise with different speeds
    vec2 shifted_uv1 = base_uv + TIME * fire_speed;
    vec2 shifted_uv2 = base_uv + TIME * fire_speed * 2.5;
	//vec2 shifted_uv3 = base_uv + TIME * fire_speed * fire_height;
    
    // Sample noise texture twice
    float fire_noise1 = texture(noise_tex, fract(shifted_uv1)).r;
    float fire_noise2 = texture(noise_tex, fract(shifted_uv2)).r;
	
    // Combine the noise samples
	float gradient = smoothstep(alt_fire_height - (box_height * 1.5), alt_fire_height, UV.y);
	float combined_noise = (fire_noise1 + fire_noise2) * 0.7 * gradient;
	if (UV.y > alt_fire_height - box_height) {
		combined_noise = combined_noise + smoothstep(alt_fire_height, 1.0, UV.y);
		combined_noise = pow(combined_noise + smoothstep(alt_fire_height, 1.0, UV.y), 2.0);
	}

    // Calculate fire shape
    float noise = gradient * (((gradient + fire_aperture) * combined_noise - fire_aperture / 3.0) * 75.0);
    
    // Add horizontal movement
    noise += sin(UV.y * 10.0 + TIME * 2.0) * 0.1;
    
    // Calculate gradient position and mix three colors
    float gradient_pos = clamp(noise * 0.08, 0.3, 2.0);
    
	vec4 fire_color = tri_color_mix(bottom_color, middle_color, top_color, gradient_pos);
	COLOR = fire_color;
	COLOR.a = clamp(noise, 0.0, 1.0);
	if (UV.y < alt_fire_height - box_height || UV.y > 0.88) {
		COLOR.a = 0.0;
	}
}
