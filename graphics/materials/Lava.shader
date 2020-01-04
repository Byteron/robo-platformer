shader_type spatial;
render_mode unshaded;

uniform sampler2D noise1;
uniform sampler2D noise2;
uniform float speed : hint_range(-1,1) = 0.0;

uniform vec4 water_color: hint_color;

void fragment() {
	float depth = texture(DEPTH_TEXTURE, SCREEN_UV).r;

	float t = TIME * speed;
	vec3 v1 = texture(noise1, UV +t).rgb;
	vec3 v2  =texture(noise2, UV -t).rgb;
	float sum = (v1.r + v2.r) - 0.7;

	vec4 back = vec4(1.0);

	if (water_color.a < 1.0) {
		back = texture(SCREEN_TEXTURE, SCREEN_UV);
	}

	float fin = 0.0;
	if (sum > 0.0 && sum <0.25) fin = 0.1;
	if (sum > 0.25 && sum <0.5) fin = 0.0;
	if (sum > 0.5) fin = 0.25;

	depth = depth * 2.0 - 1.0;
	depth = PROJECTION_MATRIX[3][2] / (depth + PROJECTION_MATRIX[2][2]);
	depth += VERTEX.z;
	// depth *= 0.1;
	depth = exp(-depth * 0.2);
	depth = clamp(depth, 0.0, 1.0);

	vec3 depth_albedo = vec3(depth, depth, depth);
	vec3 water_albedo = vec3(fin*1.0,fin*1.1,fin*0.1) + mix(back.rgb, water_color.rgb, 1.0 - depth);
	// ALBEDO = vec3(fin) + mix(back.rgb, water_color.rgb, water_color.a);

	ALBEDO = water_albedo;
//	EMISSION = water_albedo;
}

void vertex() {
	float t = TIME * speed;
	vec3 v1 = texture(noise1, UV +t).rgb;
	vec3 v2  =texture(noise2, UV -t).rgb;
	float sum = (v1.r + v2.r) - 0.7;
	VERTEX.y += sum * 2.0;
}