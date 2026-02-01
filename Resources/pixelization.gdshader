shader_type canvas_item;

// Pixelization post-processing shader
// Adjust pixel_size to control the pixelization intensity, 2.0is default, higher = more pixels 

uniform float pixel_size : hint_range(1.0, 32.0, 1.0) = 1.0;
uniform sampler2D screen_texture : hint_screen_texture, filter_nearest;

void fragment() {
	vec2 screen_size = vec2(textureSize(screen_texture, 0));
	vec2 pixel_count = screen_size / pixel_size;
	
	// Snap UV to pixel grid
	vec2 pixelated_uv = floor(SCREEN_UV * pixel_count) / pixel_count;
	
	// Sample the screen at the pixelated UV
	vec4 color = texture(screen_texture, pixelated_uv);
	
	COLOR = color;
}
