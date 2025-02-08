// https://godotshaders.com/shader/2d-outline-shader/
shader_type canvas_item;

uniform int width:hint_range(0, 5, 1);
uniform vec4 outline_color:source_color;
uniform float flickering_speed:hint_range(0.0, 50.0, 1.);
uniform float minimal_flickering_alpha:hint_range(0.0, 0.9, 0.1);

void fragment() {
	float pixel_size_x = 1.0/float(textureSize(TEXTURE,0).x);
	float pixel_size_y = 1.0/float(textureSize(TEXTURE,0).y);
	vec2 pixel_size = vec2(pixel_size_x, pixel_size_y);
	if (texture(TEXTURE, UV).a == 0.)
	{ 
		for(int x = -width; x <= width; x++)
		{
			for(int y = -width; y <= width; y++)
			{
				vec2 pixel_offset = vec2(float(x),float(y));
				if( texture(TEXTURE, UV+(pixel_offset*pixel_size)).a > 0.)
				{
					vec4 resulting_color = outline_color;
					float alpha_norm = (sin(TIME*flickering_speed) +1.2) *0.5;
					alpha_norm = (1.- minimal_flickering_alpha) * alpha_norm + minimal_flickering_alpha;
					resulting_color.a = alpha_norm;
					COLOR = resulting_color;
				}
			}
		}
	}else
	{
		COLOR = texture(TEXTURE, UV);
	}
}