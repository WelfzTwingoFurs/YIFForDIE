extends "res://Scripts/GunGeneric.gd"



func _ready():
	projectile = preload("res://Entities/BFGprojectile.tscn")
	
	
	name_string = "BFG Bio Force Gun"
	gravity = 95
	handstate = 4
	
	ammo_in = 1
	ammo_size = 1
	ammo_out = 2
	
	auto_shoot = false
	auto_reload = true
	auto_refire = false
	wait_shoot = true
	
	ground_frame = 2



func shoot():
	if $Sprite.rotation_degrees >= 180: $Sprite.rotation_degrees = 180
	else: $Sprite.rotation_degrees = 0
	
	$Sfx.shoot()
	
	var instance = projectile.instantiate()
	
	
	
	if holder:
		holder.velocity = Vector2(-1000*facing,-500)
		
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
