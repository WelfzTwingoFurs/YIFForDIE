@tool
extends TileMap
@export var on = false
@export var depth = Vector2(38,-38)
@export var light = 45
@export var intense = 1.0
@export var top_size :Array[Vector2] = [Vector2(1,1)]
#@export var topt = preload("res://Assets/test.png")
@export var topt :Array[Resource] = [preload("res://Assets/test.png")]

func _process(delta):
	if on: queue_redraw()
	if light > 360: light = 0
	if light < 0: light = 360

func array_multiply(array, multiply):
	var temp = []
	for l in array.size():
		temp.append(array[l]*multiply)
	return temp

func cell_sort(a: Vector2i, b: Vector2i) -> bool:#Credit to "gertkeno" on the Godot forums!
	if a.x == b.x:
		return (a.y > b.y) if (depth.y < 0) else (a.y < b.y)
	else:
		return (a.x > b.x) if (depth.x < 0) else (a.x < b.x)



func _draw():
	var lol = get_used_cells(0)
	lol.sort_custom(cell_sort)
	
	for t in lol:
		#print(get_cell_source_id(0, t))
		var resumo = get_cell_tile_data(0, t).get_collision_polygon_points(0,0)
		for v in resumo.size():
			var tfix = Vector2(t.x,t.y)
			var sizefix = Vector2(tile_set.tile_size.x, tile_set.tile_size.y)
			
			var curr = (sizefix/2) + (tfix*sizefix) + resumo[v]
			var next = (sizefix/2) + (tfix*sizefix) + resumo[(v+1)%resumo.size()]
			
			var poly = [curr+depth,
						next+depth,
						next,
						curr]
			
			var color = 1
			if intense != 0:
				var diff = abs(rad_to_deg(curr.angle_to_point(next)) - light)
				if (diff > 180):
					diff = 360 - diff
				color = (diff/180)
				
				if intense < 0:
					color /= -intense
				else:
					color *= intense
			
			if Geometry2D.is_polygon_clockwise(poly):
				draw_colored_polygon(poly, Color(color,color,color), array_multiply(PackedVector2Array([Vector2(1,0), Vector2(0,0), Vector2(0,1), Vector2(1,1)]), top_size[get_cell_source_id(0, t)]), topt[get_cell_source_id(0, t)])


