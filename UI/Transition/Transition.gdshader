shader_type canvas_item;

uniform float progress: hint_range(0,1);
uniform bool reverse = true;
uniform vec2 numOfTiles = vec2(15, 8.4375);

void fragment(){
	vec2 posInSquare = UV * numOfTiles;
	vec2 frac = fract(posInSquare);
	vec2 direction = abs(frac - 0.5);
	
	if(direction.x + direction.y + UV.x + UV.y >= progress * 4.0){
		if (!reverse){
			discard;
		}
	} else if (reverse){
		discard;
	}
	
	
}

