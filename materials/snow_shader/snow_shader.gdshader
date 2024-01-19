shader_type spatial;

uniform vec3 matColor;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	ALBEDO = matColor / 255.0;
}

void light() {
	vec3 absorption = vec3(0.1, 0.4, 1.0);
	vec3 resultColor = ALBEDO * ATTENUATION * LIGHT_COLOR;

	float diffuseStrength = clamp(dot(NORMAL, LIGHT) / 2.0, 0.0, 1.0);
	vec3 reflectedLight = reflect(LIGHT, NORMAL);
	float specularDot = clamp(dot(-VIEW, reflectedLight), 0.0, 1.0);
	float specularIntensity = clamp(pow(specularDot, 100), 0.0, 1.0);
	
	vec3 unabsorbedDiffuse = (1.0 - diffuseStrength) * absorption;
	
	DIFFUSE_LIGHT += clamp(resultColor * diffuseStrength + unabsorbedDiffuse, 0.0, 1.0);
	// SPECULAR_LIGHT += resultColor * specularIntensity * 0.05;
}
