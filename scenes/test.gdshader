shader_type canvas_item;

uniform sampler2D screen_texture : source_color;
void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	float value = texture(screen_texture, UV).r;
	COLOR = vec4(value, 0.0, 0.0, floor(value));
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
