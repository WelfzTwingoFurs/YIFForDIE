#@tool
extends Polygon2D
#var the_poly = [Vector2(-0.5, -0.5), Vector2(0.5, -0.5), Vector2(0.5, 0.5), Vector2(-0.5, 0.5)]
#var the_uv = [Vector2(0, 0), Vector2(1, 0), Vector2(1, 1), Vector2(0, 1
@export var resolution = Vector2(350,50)
@export var framesHV = Vector2(7,1)
@export var frame = 3
@export var verts = 3

var reference = []
var framemath = Vector2(0,0)
var raycasts = []

func refresh_all():
	if verts < 2: verts = 2
	
	reference = []
	for l in 4:
		for v in verts-1:
			var step = (1.0/(verts-1))*v
			
			match l:
				0: reference.push_back(Vector2(step,0))#top
				1: reference.push_back(Vector2(1,step))#right
				2: reference.push_back(Vector2(1-step,1))#bottom
				3: reference.push_back(Vector2(0,1-step))#left
	
	
	#framemath = Vector2(frame-(framesHV.x*int(frame/framesHV.x)), int(frame/framesHV.x))
	#uv = array_multiply(array_plus(reference,framemath), resolution/framesHV)
	refresh_frame()
	polygon = array_multiply(array_minus(reference,Vector2(0.5,0.5)), resolution/framesHV)#adjust
	
	for r in raycasts:
		r.queue_free()
	raycasts = []
	
	for p in reference.size():
		var new = $Node/RayCast.duplicate()
		new.target_position = (reference[p]*resolution/framesHV) - (Vector2(0.5,0.5)*(resolution/framesHV))
		raycasts.push_back(new)
		$Node.add_child(new)
	
	
	
	refresh_raycasts()



func refresh_frame():
	framemath = Vector2(frame-(framesHV.x*int(frame/framesHV.x)), int(frame/framesHV.x))
	uv = array_multiply(array_plus(reference,framemath), resolution/framesHV)



func refresh_raycasts():
	for p in raycasts.size():
		if raycasts[p].is_colliding():
			polygon[p] = ((raycasts[p].get_collision_point()- position)/4)*1.5 #DIVIDE BY 4 FOR ACCURACY. Not divided for BIGGER
			#polygon.push_back( (raycasts[p].get_collision_point()- position)/4 )
		else:
			polygon[p] = raycasts[p].target_position*1.5 #DON'T MULTIPLY FOR ACCURACY. Multiplied for BIGGER
			#polygon.push_back( raycasts[p].target_position )

####################################################################################################

####################################################################################################

func array_multiply(array,times):
	var temp = []
	for i in array.size():
		#array[i] *= times
		temp.push_back(array[i]*times)
	#return(array)
	return(temp)

func array_minus(array,minus):
	var temp = []
	for i in array.size():
		#array[i] -= minus
		temp.push_back(array[i]-minus)
	#return(array)
	return(temp)

func array_plus(array,plus):
	var temp = []
	for i in array.size():
		#array[i] += plus
		temp.push_back(array[i]+plus)
	#return(array)
	return(temp)

####################################################################################################

####################################################################################################

#func _draw():
	#for p in raycasts:
		#if p.is_colliding():
			#draw_circle(p.get_collision_point()/4, 2.0, Color8(randi()%256,randi()%256,randi()%256))
		#else:
			#draw_circle(p.target_position, 2.0, Color8(randi()%256,randi()%256,randi()%256))
	#
	#for v in polygon.size()-1:
		#draw_line(polygon[v],polygon[v+1],Color8(randi()%256,randi()%256,randi()%256))
	#draw_line(polygon[polygon.size()-1],polygon[0],Color8(randi()%256,randi()%256,randi()%256))
	#
	#for v in uv.size()-1:
		#draw_line(uv[v],uv[v+1],Color8(randi()%256,randi()%256,randi()%256))
	#draw_line(uv[uv.size()-1],uv[0],Color8(randi()%256,randi()%256,randi()%256))

####################################################################################################

####################################################################################################

var tag = -1
func _ready():
	tag = (Time.get_ticks_usec()+Time.get_ticks_msec())
	$AniPlay.play("boom")
	$Sfx.play()

var was_frame = -1
var was_verts = -1
func _process(_delta):
	if (was_frame != frame):
		refresh_frame()
		was_frame = frame
	
	if (was_verts != verts):
		refresh_all()
		was_verts = verts
	
	if col_on:
		refresh_raycasts()
		get_colliders()
	elif !$Sfx.playing:
		queue_free()

var col_on = true
func col_disable():
	col_on = false

####################################################################################################

####################################################################################################

var damage = 70
var knockback = 1000
var stun = 150
var knock_replace = true
var facing = 1
func get_colliders():
	for r in raycasts: if r.is_colliding():
		if r.get_collider().is_in_group("player") && (r.get_collider().was_tag != tag):
			r.get_collider().was_tag = tag
			facing = -1#sign(r.get_collider().position.x - position.x)
			
			var distance2 =  ((r.get_collision_point()-position)/3) / (resolution/framesHV)
			var distance_to = Vector2(0,0).distance_to(distance2)
			#print(facing,"\n",knockback * (distance2*10),"\n")
			
			r.get_collider().take_damage(damage*distance_to*10, knockback*distance2*10, stun*distance_to*4, self, tag)
