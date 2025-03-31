extends "res://Scripts/GunGeneric.gd"



func _ready():
	projectile = preload("res://Entities/RocketGeneric.tscn")
	
	
	name_string = "RPG Rocket Launcher"
	gravity = 75
	handstate = 5
	
	ammo_in = 1
	ammo_size = 1
	ammo_out = 3
	
	auto_shoot = false
	auto_reload = true
	auto_refire = false
	wait_shoot = true
	
	flash_pos = $Flash.position.x
	$Flash.visible = false
	
	ground_frame = 2
	ground_frame2 = 3
	weight_divi = 1.1
@onready var flash_pos2 = $Flash2.position.x



func shoot():
	if $Sprite.rotation_degrees >= 180: $Sprite.rotation_degrees = 180
	else: $Sprite.rotation_degrees = 0
	
	$Sfx.shoot()
	$Flash.flip_v = randi() % 2
	if holder:
		$Flash2.scale.x  = holder.facing
	$Flash2.position.x = flash_pos2 * (holder.facing if holder else 1)
	$Flash2.flip_v = randi() % 2
	
	var instance = projectile.instantiate()
	
	#instance.damage = 40
	#instance.knockback = Vector2(-1000,0)
	#instance.knock_replace = true
	#instance.stun = 10
	#instance.speed = 7500.0
	#instance.gravity = 20.0
	
	if holder:
		holder.velocity = Vector2(-1000*holder.facing,-500)
		
		instance.add_collision_exception_with(holder)
	instance.add_collision_exception_with(self)
	
	instance.facing = (holder.facing if holder else facing)
	instance.position = position + Vector2(100*(holder.facing if holder else facing),-6 * (-1 if ($Sprite.rotation_degrees >= 180) else 1))
	
	get_parent().add_child(instance)


func release():
	$Sfx.release()
	ammo_in = 0
	
	var instance = guncase.instantiate()
	instance.position = position + Vector2(-12*(holder.facing if holder else facing),0)
	instance.velocity = velocity
	get_parent().add_child(instance)

func reload():
	$Sfx.reload()
	if ammo_out > ammo_size:
		ammo_in = ammo_size
		ammo_out -= ammo_size
	else:
		ammo_in = ammo_out
		ammo_out = 0

func set_handstate(valoo): handstate = valoo
 
func set_busy(yeah): busy = yeah



#func _on_too_close_body_exited(body):
	#if closers.has(body):
		#closers.erase(body)
#
#
#func _on_too_close_body_entered(body):
	#if body.is_in_group("player") && !closers.has(body):
		#closers.push_back(body)
