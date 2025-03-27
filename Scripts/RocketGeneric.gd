extends CharacterBody2D

@export var speed = 2500.0
@export var gravity = 5.0
@export var damage = 40
@export var knockback = Vector2(-100,-100)
@export var knock_replace = false
@export var stun = 50
var facing = 1

func _physics_process(_delta):
	move_and_slide()
	velocity.y += gravity
	
	if is_on_floor() or is_on_wall() or is_on_ceiling():
		#for b in $Area.get_overlapping_bodies():
		#	_on_area_body_entered(b)
		explode()
	

var explosion = preload("res://Entities/Explosion.tscn")
func _on_area_body_entered(body):
	if body.is_in_group("player"):
		body.take_damage(damage, knockback, stun, self, -1)
	explode()

func _ready():
	$Sfx.play()
	$Sprite.play("default")
	$Sprite.scale.x = facing
	velocity = Vector2(speed*facing, 0).rotated(rotation)

var dontexplodetwice = false
func explode():
	if !dontexplodetwice:
		dontexplodetwice = true
		var instance = explosion.instantiate()
		instance.position = position #+ Vector2(20*facing,0)
		get_parent().add_child(instance)
		queue_free()
