shader_type canvas_item;
render_mode blend_add;

// Based on http://rastergrid.com/blog/2010/09/efficient-gaussian-blur-with-linear-sampling/

vec4 blur5(sampler2D image, vec2 uv, vec2 pixel_size, vec2 direction) {
	vec4 color = vec4(0.0);
	vec2 off1 = vec2(1.3333333333333333) * direction;
	color += texture(image, uv) * 0.29411764705882354;
	color += texture(image, uv + (off1 * pixel_size)) * 0.35294117647058826;
	color += texture(image, uv - (off1 * pixel_size)) * 0.35294117647058826;
	return color; 
}


  
vec4 blur9(sampler2D image, vec2 uv, vec2 pixel_size, vec2 direction) {
	vec4 color = vec4(0.0);
	vec2 off1 = vec2(1.3846153846) * direction;
	vec2 off2 = vec2(3.2307692308) * direction;
	color += texture(image, uv) * 0.2270270270;
	color += texture(image, uv + (off1 * pixel_size)) * 0.3162162162;
	color += texture(image, uv - (off1 * pixel_size)) * 0.3162162162;
	color += texture(image, uv + (off2 * pixel_size)) * 0.0702702703;
	color += texture(image, uv - (off2 * pixel_size)) * 0.0702702703;
	return color;
}


vec4 blur13(sampler2D image, vec2 uv, vec2 pixel_size, vec2 direction) {
	vec4 color = vec4(0.0);
	vec2 off1 = vec2(1.411764705882353) * direction;
	vec2 off2 = vec2(3.2941176470588234) * direction;
	vec2 off3 = vec2(5.176470588235294) * direction;
	color += texture(image, uv) * 0.1964825501511404;
	color += texture(image, uv + (off1 * pixel_size)) * 0.2969069646728344;
	color += texture(image, uv - (off1 * pixel_size)) * 0.2969069646728344;
	color += texture(image, uv + (off2 * pixel_size)) * 0.09447039785044732;
	color += texture(image, uv - (off2 * pixel_size)) * 0.09447039785044732;
	color += texture(image, uv + (off3 * pixel_size)) * 0.010381362401148057;
	color += texture(image, uv - (off3 * pixel_size)) * 0.010381362401148057;
	return color;
}


void fragment() {
	COLOR = blur9(TEXTURE, UV, TEXTURE_PIXEL_SIZE, vec2(2,2));
}