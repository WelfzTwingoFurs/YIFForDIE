extends CharacterBody2D

@export var speed = 850.0
@export var damage = 80
@export var knockback = Vector2(0,0)
@export var knock_replace = false
@export var stun = 150
var facing = 1


func _physics_process(_delta):
	scale = lerp(scale, Vector2(1,1), 0.25)
	
	move_and_slide()
	
	if is_on_floor() or is_on_wall() or is_on_ceiling():
		$AniPlay.play("explode")
	
	for r in raycasts:
		if r.is_colliding() && r.get_collider().is_in_group("player"):
			shock(r.get_collider())
	
	queue_redraw()

func _draw():
	for r in raycasts:
		if r.is_colliding():# && r.get_collider().is_in_group("player"):
			draw_line(Vector2(0,0), (r.get_collision_point()-position)*(1/scale.x), Color(0,0,0), 7.5)
			draw_line(Vector2(0,0), (r.get_collision_point()-position)*(1/scale.x), Color(randi()%2,1,0), 3.0)
		#else:
		#	draw_line(Vector2(0,0), r.target_position/1.1, Color(1,1,1,0.01), 25.0)










func shock(body):
	if body.is_in_group("player"):
		body.take_damage(3.5, knockback, 0, self, -1)
		$Sfx.play()

func _on_area_body_entered(body):
	if body.is_in_group("player"):
		knock_replace = true
		body.take_damage(damage, knockback, stun, self, -1)
	$AniPlay.play("explode")
	velocity = Vector2(0,0)

var raycasts = []
func _ready():
	$AniPlay.play("idle")
	velocity = Vector2(speed*facing, 0).rotated(rotation)
	
	for r in 32:
		var new = $RayCast.duplicate()
		#new.rotation_degrees = (360/32)*r
		new.target_position = $RayCast.target_position.rotated( ((360/32)*r)*(PI/180) )
		raycasts.push_back(new)
		add_child(new)


func random_flips():
	$Sprite.flip_h = true if (randi()%2 == 0) else false
	$Sprite.flip_v = true if (randi()%2 == 0) else false
	if (randi()%2 == 0): $Sprite.rotation_degrees += 90

func grow_raycasts():
	for r in raycasts:
		r.scale = Vector2(2,2)
