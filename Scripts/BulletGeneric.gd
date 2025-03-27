extends CharacterBody2D

var damage = 15
var knockback = Vector2(-250,-250)
var knock_replace = true
var stun = 10
var facing = 1
var speed = 3000.0
var dietime = 20.0
var gravity = 1.0
var deaccel = 0.0
var tag = -1
var holder = null

func _physics_process(_delta):
	move_and_slide()
	velocity.x = lerp(velocity.x, 0.0, deaccel)
	velocity.y -= gravity
	
	if dietime != INF:
		dietime -= 1
		if dietime <= 0: queue_free()
	
	if is_on_floor() or is_on_wall() or is_on_ceiling():
		for b in $Area.get_overlapping_bodies():
			_on_area_body_entered(b)
		queue_free()
	
	
	
	if $RayCast.is_colliding() && $RayCast.get_collider().is_in_group("player"):
		_on_area_body_entered($RayCast.get_collider())
	
	$RayCast.target_position = -(was_position-position)/2
	#$RayCast.target_position = position - velocity
	was_position = position
@onready var was_position = position


var start_dietime = 0
var start_pos = Vector2(0,0)
func _ready():
	start_dietime = dietime
	$Sprite.scale.x = facing
	velocity = Vector2(speed*facing, 0).rotated(rotation)
	start_pos = position


func _process(_delta): queue_redraw()

func _draw():
	var color = ( (start_dietime/ (start_dietime/dietime)) )/start_dietime
	#var color = (start_dietime-(start_dietime/dietime))/start_dietime
	draw_line((start_pos - position).rotated(-rotation)/scale, Vector2(0,0), Color(color,color,color,color), color*2)


func _on_area_body_entered(body):
	if (body != holder) && body.is_in_group("player") && ((tag == -1) or (body.was_tag != tag)):
		body.was_tag = tag
		
		var instance = hitstar.instantiate()
		instance.position = position
		get_parent().add_child(instance)
		
		position -= velocity
		body.take_damage(damage, knockback, stun, self, tag)
		queue_free()
	else:
		print("fuck")


var hitstar = preload("res://Entities/ParticlesEffects/Effect_Hitstar.tscn")
