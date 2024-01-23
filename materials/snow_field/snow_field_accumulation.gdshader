shader_type canvas_item;

uniform sampler2D screen_texture : source_color;

const int M = 4;
const int N = 2 * M + 1;
const float SIZE_INV = 1.0 / 512.0;
const float coeffs[9] = float[](
	0.003906250000,
	0.03125000000,
	0.1093750000,
	0.2187500000,
	0.2734375000,
	0.2187500000,
	0.1093750000,
	0.03125000000,
	0.003906250000
);

vec4 gaussian(vec2 uv)
{
	vec4 sum = vec4(0.0);
	for (int i = 0; i < N; ++i)
	{
		for (int j = 0; j < N; ++j)
		{
			vec2 tc = uv + SIZE_INV * vec2(float(i - M), float(j - M));
			sum += coeffs[i] * coeffs[j] * texture(screen_texture, tc);
			// sum += 0.1 * texture(screen_texture, tc);
		}
	}
	return sum;
}

void fragment() {
	COLOR = gaussian(UV);
}