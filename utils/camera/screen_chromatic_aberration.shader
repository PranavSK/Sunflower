shader_type canvas_item;

uniform vec2 amount = vec2(1.0, 1.0);

void fragment() {
	vec2 adjusted_amount = amount * SCREEN_PIXEL_SIZE;
	COLOR.r = texture(SCREEN_TEXTURE, SCREEN_UV + adjusted_amount).r;
	COLOR.g = texture(SCREEN_TEXTURE, SCREEN_UV).g;
	COLOR.b = texture(SCREEN_TEXTURE, SCREEN_UV - adjusted_amount).b;
	COLOR.a = texture(SCREEN_TEXTURE, SCREEN_UV).a;
}