shader_type spatial;

uniform sampler2D displacement_texture : source_color;
uniform vec3 matColor;
uniform float depthScale;

void vertex() {
	VERTEX.y += (1.0 - texture(displacement_texture, UV).r) * depthScale;
}

void fragment() {
	ALBEDO = matColor / 255.0;
	ALBEDO *=  1.0 - (pow(texture(displacement_texture, UV).r, 2.0) / 2.0);
}

void light() {
	vec3 absorption = vec3(0.1, 0.4, 1.0);
	vec3 resultColor = ALBEDO * ATTENUATION * LIGHT_COLOR;
	// resultColor += (1.0 - ATTENUATION) * absorption;

	//float snowAbsoprtion = pow(texture(displacement_texture, UV).r, 0.25) / 4.0;
	float diffuseStrength = clamp(dot(NORMAL, LIGHT) / 2.0, 0.0, 1.0) /*- snowAbsoprtion*/;
	vec3 reflectedLight = reflect(LIGHT, NORMAL);
	float specularDot = clamp(dot(-VIEW, reflectedLight), 0.0, 1.0);
	float specularIntensity = clamp(pow(specularDot, 100), 0.0, 1.0);
	
	vec3 unabsorbedDiffuse = (1.0 - diffuseStrength) * absorption;
	
	DIFFUSE_LIGHT += clamp(resultColor * diffuseStrength + unabsorbedDiffuse, 0.0, 1.0);
	// SPECULAR_LIGHT += resultColor * specularIntensity * 0.05;
}