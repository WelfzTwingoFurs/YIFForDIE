@tool
extends Node2D

@export var angle = 0.0
@export var light = 45.0

func _process(delta):
	queue_redraw()
	if angle < 0: angle = 360.0
	if angle > 360: angle = 0.0
	
	if light < 0: light = 360.0
	if light > 360: light = 0.0

func _draw():
	var diff = abs(angle - light)
	if (diff > 180):
		diff = 360 - diff
	
	var color = 1-(diff/180)
	
	draw_line(Vector2(100,0).rotated(deg_to_rad(angle)), Vector2(-100,0).rotated(deg_to_rad(angle)), Color(color,color,color), 10)
	draw_line(Vector2(0,0), Vector2(0,-50).rotated((deg_to_rad(angle))), Color(1,1,1), 5)
	
	
	
	
	
	
	
	
	
	
	
	
	
	draw_string(ThemeDB.fallback_font, Vector2(), str(color), HORIZONTAL_ALIGNMENT_CENTER, -1, 20, Color(1,0,0))
	
	draw_string(ThemeDB.fallback_font, Vector2(0,-125).rotated(deg_to_rad(light)), str(int(light)), HORIZONTAL_ALIGNMENT_CENTER, -1, 20, Color(1,1,1))
	
	draw_string(ThemeDB.fallback_font, Vector2(0,-125).rotated(deg_to_rad(angle)), str(int(angle)), HORIZONTAL_ALIGNMENT_CENTER, -1, 20, Color(1,1,0))
	
	draw_string(ThemeDB.fallback_font, Vector2(0,-100).rotated(deg_to_rad(0)), str(0), HORIZONTAL_ALIGNMENT_CENTER, -1, 20, Color(1,0,1))
	draw_string(ThemeDB.fallback_font, Vector2(0,-100).rotated(deg_to_rad(45)), str(45), HORIZONTAL_ALIGNMENT_CENTER, -1, 20, Color(1,0,1))
	draw_string(ThemeDB.fallback_font, Vector2(0,-100).rotated(deg_to_rad(90)), str(90), HORIZONTAL_ALIGNMENT_CENTER, -1, 20, Color(1,0,1))
	draw_string(ThemeDB.fallback_font, Vector2(0,-100).rotated(deg_to_rad(135)), str(135), HORIZONTAL_ALIGNMENT_CENTER, -1, 20, Color(1,0,1))
	draw_string(ThemeDB.fallback_font, Vector2(0,-100).rotated(deg_to_rad(180)), str(180), HORIZONTAL_ALIGNMENT_CENTER, -1, 20, Color(1,0,1))
	draw_string(ThemeDB.fallback_font, Vector2(0,-100).rotated(deg_to_rad(225)), str(225), HORIZONTAL_ALIGNMENT_CENTER, -1, 20, Color(1,0,1))
	draw_string(ThemeDB.fallback_font, Vector2(0,-100).rotated(deg_to_rad(270)), str(270), HORIZONTAL_ALIGNMENT_CENTER, -1, 20, Color(1,0,1))
	draw_string(ThemeDB.fallback_font, Vector2(0,-100).rotated(deg_to_rad(315)), str(315), HORIZONTAL_ALIGNMENT_CENTER, -1, 20, Color(1,0,1))
