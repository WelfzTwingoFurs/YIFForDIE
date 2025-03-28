extends Camera2D
@export var focus = -1
var players = []
func _ready():
	refresh_targets()



func refresh_targets():
	players = []
	for target in get_parent().get_children():
		if target.is_in_group("player") && target.HP > 0:
			players.append(target)
	
	if focus > players.size()-1:
		focus = players.size()-1



var limit = INF
var edges = Vector4(INF,INF,INF,INF)
func _process(_delta):
	refresh_targets()
	var most_left = INF
	var most_right = -INF
	var most_up = INF
	var most_down = -INF
	
	if players:
		var here = Vector2()
		if focus == -1:
			for n in players:
				if n.HP > 0:
					here += n.position
					
					if n.position.x < most_left: most_left = n.position.x
					if n.position.x > most_right: most_right = n.position.x
					if n.position.y < most_up: most_up = n.position.y
					if n.position.y > most_down: most_down = n.position.y
			
			
			
			objective_position = Vector2(0,-100)+here/players.size()
			var distance = Vector2(most_left, most_up).distance_to(Vector2(most_right, most_down))
			if distance > limit*2: distance = limit*2
			
			if distance != 0:
				var wow
				if get_viewport().size.x > get_viewport().size.y: 
					wow = (get_viewport().size/distance) / Vector2(float(get_viewport().size.x)/float(get_viewport().size.y), 1)
				else: 
					wow = (get_viewport().size/distance) / Vector2(1, float(get_viewport().size.y)/float(get_viewport().size.x))
				
				
				if (wow.x > 1) or (wow.y > 1) or (wow.x == 0) or (wow.y == 0): 
					objective_zoom = Vector2(1,1)
				else: 
					objective_zoom = wow
				
			else:
				refresh_targets()
				objective_zoom = Vector2(1,1)
			
			
		
		
		else:
			#if players[focus].player != focus:
			#	focus = players[focus].player
			objective_position_speed = 1
			objective_zoom_speed = 1
			objective_position = Vector2(0,-100)+players[focus].position
			objective_zoom = Vector2(1,1)
	
	
	position = lerp(position, objective_position, objective_position_speed)
	zoom = lerp(zoom, objective_zoom, objective_zoom_speed)
	
var objective_zoom = Vector2(1,1)
var objective_position = Vector2(1,1)
var objective_position_speed = 0.01
var objective_zoom_speed = 0.01










		#if stretchy:
			#if get_viewport().size.x/(distances.x*1.5) < 1: zoom.x = get_viewport().size.x/(distances.x*1.5)
			#else: zoom.x = 1
			#if get_viewport().size.y/(distances.y*1.5) < 1: zoom.y = get_viewport().size.y/(distances.y*1.5)
			#else: zoom.y = 1
