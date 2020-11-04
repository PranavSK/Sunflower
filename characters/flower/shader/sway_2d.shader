/**
 * Shader settings avaiable from Editor/GDscript.
 * 	float speed - The speed of the wind movement.
 * 	float minStrength - The minimal strength of the wind movement.
 * 	float maxStrength - The maximal strength of the wind movement.
 * 	float strengthScale - Scalefactor for the wind strength.
 * 	float interval - The time between minimal and maximal strength changes.
 * 	float detail - The detail (number of waves) of the wind movement.
 * 	float distortion - The strength of geometry distortion.
 * 	float heightOffset - The height where the wind begins to move. By default 0.0.
 */

shader_type canvas_item;
render_mode blend_mix;

// Wind settings.
uniform float speed = 1.0;
uniform float minStrength : hint_range(0.0, 1.0);
uniform float maxStrength : hint_range(0.0, 1.0);
uniform float strengthScale = 100.0;
uniform float interval = 3.5;
uniform float detail = 1.0;
uniform float distortion : hint_range(0.0, 1.0);
uniform float heightOffset = 0.0;


float getWind(vec2 vertex, vec2 uv, float timer) {
	vec2 pos = mix(vec2(1.0), vertex, distortion).xy;
	float time = timer * speed + pos.x * pos.y;
	float diff = pow(maxStrength - minStrength, 2.0);
	float strength = clamp(minStrength + diff + sin(time / interval) * diff, minStrength, maxStrength) * strengthScale;
	float wind = (sin(time) + cos(time * detail)) * strength * max(0.0, (1.0-uv.y) - heightOffset);
	
	return wind;
}


void vertex() {
	VERTEX.x += getWind(VERTEX.xy, UV, TIME);
}