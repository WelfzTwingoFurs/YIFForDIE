shader_type canvas_item;

uniform int player;
uniform vec4 player1[13] : source_color;
uniform vec4 player2[13] : source_color;
uniform vec4 player3[13] : source_color;
uniform vec4 player4[13] : source_color;




bool colorCheck(vec4 color, vec4 test) {
	float threshold = 0.01;
	
	if (test.r > color.r - threshold 
	&& test.r < color.r + threshold
	&&
	test.g > color.g - threshold 
	&& test.g < color.g + threshold
	&&
	test.b > color.b - threshold 
	&& test.b < color.b + threshold)
		{return true;}
	
	return false;}


uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

void fragment() {
	if (player > 1) {
		vec4 pixel = texture(screen_texture,SCREEN_UV);
		//vec4 pixel = texture(TEXTURE,UV);
		
		for (int c = 0; c < (player1.length()); c++) {
			if (colorCheck (pixel, player1[c])) {
				if (player == 2) {COLOR = player2[c];}
				if (player == 3) {COLOR = player3[c];}
				if (player == 4) {COLOR = player4[c];}
				}
			}
		}
	}
