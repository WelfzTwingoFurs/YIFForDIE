@tool
extends StaticBody2D

@export var topt = preload("res://TEST/top.png")
@export var top_size = Vector2(1,1)
@export var linet = preload("res://TEST/line.png")
@export var line_size = Vector2(1,1)
@export var fillt = preload("res://TEST/pattern.png")
@export var fill_size = Vector2(1,1)

func array_divide(array, divide):
	var temp = []
	for l in array.size():
		temp.append(array[l]/divide)
	return temp

func array_multiply(array, multiply):
	var temp = []
	for l in array.size():
		temp.append(array[l]*multiply)
	return temp




func _process(delta):
	queue_redraw()
	#print(Vector2(100,100)*fill.get_size()/Vector2(2,1))

func _draw():
	#polygon fill
	draw_colored_polygon($CollisionPolygon2D.polygon, Color(1,1,1, 1), array_divide($CollisionPolygon2D.polygon, fillt.get_size()*fill_size), fillt)
	################################################################################################
	################################################################################################
	
	
	#lines##########################################################################################
	for v in $CollisionPolygon2D.polygon.size():
		var angle = $CollisionPolygon2D.polygon[v].angle_to($CollisionPolygon2D.polygon[(v+1)%$CollisionPolygon2D.polygon.size()])
		
		var size = linet.get_size().y*line_size.y
		
		var line = [
			$CollisionPolygon2D.polygon[v],
			$CollisionPolygon2D.polygon[(v+1)%$CollisionPolygon2D.polygon.size()],
			$CollisionPolygon2D.polygon[(v+1)%$CollisionPolygon2D.polygon.size()] + Vector2(0,50).rotated(angle),
			$CollisionPolygon2D.polygon[v] + Vector2(0,size).rotated(angle),
		]
		
		if Geometry2D.is_polygon_clockwise(line):
			line[2] = $CollisionPolygon2D.polygon[(v+1)%$CollisionPolygon2D.polygon.size()] - Vector2(0,50).rotated(angle)
			line[3] = $CollisionPolygon2D.polygon[v] - Vector2(0,size).rotated(angle)
		
		draw_colored_polygon(line, Color(1,1,1), array_multiply(PackedVector2Array([Vector2(0,0), Vector2(1,0), Vector2(1,1), Vector2(0,1)]), Vector2(line_size.x,1)), linet)
	################################################################################################
	################################################################################################
	
	
	#perspective####################################################################################
	for v in $CollisionPolygon2D.polygon.size():
		
		var poly = [
			$CollisionPolygon2D.polygon[v]+Vector2(38,-38),
			$CollisionPolygon2D.polygon[(v+1)%$CollisionPolygon2D.polygon.size()]+Vector2(38,-38),
			$CollisionPolygon2D.polygon[(v+1)%$CollisionPolygon2D.polygon.size()],
			$CollisionPolygon2D.polygon[v]
			]
		
		if !Geometry2D.is_polygon_clockwise(poly):
			draw_colored_polygon(poly, Color(1,1,1, 1), array_multiply(PackedVector2Array([Vector2(0,0), Vector2(1,0), Vector2(1,1), Vector2(0,1)]), top_size), topt)
	################################################################################################
	################################################################################################









