@tool
extends StaticBody2D

@export var depth = Vector2(38,-38)
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
	#perspective####################################################################################
	for v in $CollisionPolygon2D.polygon.size():
		
		var poly = [
			$CollisionPolygon2D.polygon[v]+depth,
			$CollisionPolygon2D.polygon[(v+1)%$CollisionPolygon2D.polygon.size()]+depth,
			$CollisionPolygon2D.polygon[(v+1)%$CollisionPolygon2D.polygon.size()],
			$CollisionPolygon2D.polygon[v]
			]
		
		if !Geometry2D.is_polygon_clockwise(poly):
			draw_colored_polygon(poly, Color(1,1,1, 1), array_multiply(PackedVector2Array([Vector2(0,0), Vector2(1,0), Vector2(1,1), Vector2(0,1)]), top_size), topt)
	################################################################################################
	################################################################################################
	
	
	#polygon fill
	draw_colored_polygon($CollisionPolygon2D.polygon, Color(1,1,1, 1), array_divide($CollisionPolygon2D.polygon, fillt.get_size()*fill_size), fillt)
	################################################################################################
	################################################################################################
	
	
	#lines##########################################################################################
	var lines = []
	for v in $CollisionPolygon2D.polygon.size():
		var I = $CollisionPolygon2D.polygon[v]
		var II = $CollisionPolygon2D.polygon[(v+1)%$CollisionPolygon2D.polygon.size()]
		#draw_line(I, II, Color(1,1,1))
		
		var D = Vector2(II.x - I.x,   II.y - I.y)
		var Final1 = Vector2(-D.y, D.x)
		var Final2 = Vector2(D.y, -D.x)
		#draw_line(Final1, Final2, Color(1,1,1))
		
		var angle = (Final1.angle_to_point(Final2))
		#draw_string(ThemeDB.fallback_font, (I+II)/2, str(angle))
		
		var Under1 = I + Vector2(-line_size.y,0).rotated(angle)
		var Under2 = II + Vector2(-line_size.y,0).rotated(angle)
		#draw_line(Under1, Under2, Color(1,0,0))
		
		lines.append(Vector4(Under1.x, Under1.y, Under2.x, Under2.y))
	
	var points = []
	for g in lines.size():
		var A1 = Vector2(lines[g].x, lines[g].y)
		var B1 = Vector2(lines[g].z, lines[g].w)
		#draw_line(A1, B1, Color(0,1,0), 5)
		
		var A2 = Vector2(lines[(g+1) % lines.size()].x, lines[(g+1) % lines.size()].y)
		var B2 = Vector2(lines[(g+1) % lines.size()].z, lines[(g+1) % lines.size()].w)
		#draw_line(A2, B2, Color(0,0,1), 10)
		
		var X = ( (A1.x*B1.y-A1.y*B1.x)*(A2.x-B2.x)-(A1.x-B1.x)*(A2.x*B2.y-A2.y*B2.x) ) / ( (A1.x-B1.x)*(A2.y-B2.y)-(A1.y-B1.y)*(A2.x-B2.x) ) 
		var Y = ( (A1.x*B1.y-A1.y*B1.x)*(A2.y-B2.y)-(A1.y-B1.y)*(A2.x*B2.y-A2.y*B2.x) ) / ( (A1.x-B1.x)*(A2.y-B2.y)-(A1.y-B1.y)*(A2.x-B2.x) )
		#draw_circle(Vector2(X,Y),10, Color(1,0,0))
		
		points.append(Vector2(X,Y))
	
	for v in $CollisionPolygon2D.polygon.size():
		var line = [
			$CollisionPolygon2D.polygon[v],
			$CollisionPolygon2D.polygon[(v+1)%$CollisionPolygon2D.polygon.size()],
			points[(v) % points.size()],
			points[(v-1) % points.size()],
		]
		
		draw_colored_polygon(line, Color(1,1,1), array_multiply(PackedVector2Array([Vector2(0,0), Vector2(1,0), Vector2(1,1), Vector2(0,1)]), Vector2(line_size.x,1)), linet)
	
	################################################################################################
	################################################################################################
	#var lines = []
	#for v in $CollisionPolygon2D.polygon.size():
		#var I = $CollisionPolygon2D.polygon[v]
		#var II = $CollisionPolygon2D.polygon[(v+1)%$CollisionPolygon2D.polygon.size()]
		##draw_line(I, II, Color(1,1,1))
		#
		#var D = Vector2(II.x - I.x,   II.y - I.y)
		#var Final1 = Vector2(-D.y, D.x)
		#var Final2 = Vector2(D.y, -D.x)
		##draw_line(Final1, Final2, Color(1,1,1))
		#
		#var angle = (Final1.angle_to_point(Final2))
		##draw_string(ThemeDB.fallback_font, (I+II)/2, str(angle))
		#
		#var Under1 = I + Vector2(-10,0).rotated(angle)
		#var Under2 = II + Vector2(-10,0).rotated(angle)
		##draw_line(Under1, Under2, Color(1,0,0))
		#
		#lines.append(Vector4(Under1.x, Under1.y, Under2.x, Under2.y))
	#
	#for g in lines.size():
		#var A1 = Vector2(lines[g].x, lines[g].y)
		#var B1 = Vector2(lines[g].z, lines[g].w)
		#draw_line(A1, B1, Color(0,1,0), 5)
		#
		#var A2 = Vector2(lines[(g+1) % lines.size()].x, lines[(g+1) % lines.size()].y)
		#var B2 = Vector2(lines[(g+1) % lines.size()].z, lines[(g+1) % lines.size()].w)
		#draw_line(A2, B2, Color(0,0,1), 10)
		#
		#var X = ( (A1.x*B1.y-A1.y*B1.x)*(A2.x-B2.x)-(A1.x-B1.x)*(A2.x*B2.y-A2.y*B2.x) ) / ( (A1.x-B1.x)*(A2.y-B2.y)-(A1.y-B1.y)*(A2.x-B2.x) ) 
		#var Y = ( (A1.x*B1.y-A1.y*B1.x)*(A2.y-B2.y)-(A1.y-B1.y)*(A2.x*B2.y-A2.y*B2.x) ) / ( (A1.x-B1.x)*(A2.y-B2.y)-(A1.y-B1.y)*(A2.x-B2.x) )
		#draw_circle(Vector2(X,Y),10, Color(1,0,0))
	################################################################################################
	################################################################################################
	#var lines = []
	#for v in $CollisionPolygon2D.polygon.size():
		#var I = $CollisionPolygon2D.polygon[v]
		#var II = $CollisionPolygon2D.polygon[(v+1)%$CollisionPolygon2D.polygon.size()]
		#draw_line(I, II, Color(1,1,1))
		#
		#var D = Vector2(II.x - I.x,   II.y - I.y)
		#var Final1 = Vector2(-D.y, D.x)
		#var Final2 = Vector2(D.y, -D.x)
		##draw_line(Final1, Final2, Color(1,1,1))
		#
		#var angle = (Final1.angle_to_point(Final2))
		##draw_string(ThemeDB.fallback_font, (I+II)/2, str(angle))
		#
		#var Under1 = I + Vector2(-10,0).rotated(angle)
		#var Under2 = II + Vector2(-10,0).rotated(angle)
		#draw_line(Under1, Under2, Color(1,0,0))
		#
		#lines.append(Vector4(Under1.x, Under1.y, Under2.x, Under2.y))
	#
	#for g in lines.size()-1:
		#var A1 = Vector2(lines[g].x, lines[g].y)
		#var B1 = Vector2(lines[g].z, lines[g].w)
		#draw_line(A1, B1, Color(0,1,0), 5)
		#
		#var A2 = Vector2(lines[(g+1) % lines.size()].x, lines[(g+1) % lines.size()].y)
		#var B2 = Vector2(lines[(g+1) % lines.size()].z, lines[(g+1) % lines.size()].w)
		#draw_line(A2, B2, Color(0,0,1), 10)
		#
		#var C1 = A1.x + B1.y
		#var C2 = A2.x + B2.y
		#
		#var X = ((C1*B2)-(C2*B1)) / ((A1*B2)-(A2*B1))
		#var Y = ((A1*C2)-(A2*C1)) / (A1*B2)-(A2*B1)
		#draw_circle(X, 10, Color(1,0,1))
	################################################################################################
	################################################################################################
		#var I = $CollisionPolygon2D.polygon[v]
		#var II = $CollisionPolygon2D.polygon[(v+1)%$CollisionPolygon2D.polygon.size()]
		#draw_line(I, II, Color(1,1,1))
		#
		#var D = Vector2(II.x - I.x,   II.y - I.y)
		#var Final1 = Vector2(-D.y, D.x)
		#var Final2 = Vector2(D.y, -D.x)
		#draw_line(Final1, Final2, Color(1,1,1))
		#
		#var angle = (Final1.angle_to_point(Final2))
		#draw_string(ThemeDB.fallback_font, (I+II)/2, str(angle))
		#
		#var Under1 = I + Vector2(-10,0).rotated(angle)
		#var Under2 = II + Vector2(-10,0).rotated(angle)
		#draw_line(Under1, Under2, Color(1,0,0))
	################################################################################################
	################################################################################################
	#for v in $CollisionPolygon2D.polygon.size():
		#var angle = $CollisionPolygon2D.polygon[v].angle_to($CollisionPolygon2D.polygon[(v+1)%$CollisionPolygon2D.polygon.size()])
		#
		#draw_string(ThemeDB.fallback_font,($CollisionPolygon2D.polygon[v]+$CollisionPolygon2D.polygon[(v+1)%$CollisionPolygon2D.polygon.size()])/2,str(angle))
		#
		#var size = linet.get_size().y*line_size.y
		#
		#var line = [
			#$CollisionPolygon2D.polygon[v],
			#$CollisionPolygon2D.polygon[(v+1)%$CollisionPolygon2D.polygon.size()],
			#$CollisionPolygon2D.polygon[(v+1)%$CollisionPolygon2D.polygon.size()] + Vector2(0,50).rotated(angle),
			#$CollisionPolygon2D.polygon[v] + Vector2(0,size).rotated(angle),
		#]
		#
		#if Geometry2D.is_polygon_clockwise(line):
			#line[2] = $CollisionPolygon2D.polygon[(v+1)%$CollisionPolygon2D.polygon.size()] - Vector2(0,50).rotated(angle)
			#line[3] = $CollisionPolygon2D.polygon[v] - Vector2(0,size).rotated(angle)
		#
		#draw_colored_polygon(line, Color(1,1,1), array_multiply(PackedVector2Array([Vector2(0,0), Vector2(1,0), Vector2(1,1), Vector2(0,1)]), Vector2(line_size.x,1)), linet)
	#################################################################################################
	#################################################################################################



