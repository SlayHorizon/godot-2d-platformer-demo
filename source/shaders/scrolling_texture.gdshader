shader_type canvas_item;

uniform vec2 direction = vec2(0.0, -1.0);
uniform float speed = 0.5;

void fragment() {
	COLOR = texture(TEXTURE, UV + (direction * speed * TIME));
}
