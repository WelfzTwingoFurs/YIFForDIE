extends "res://Scripts/GunGeneric.gd"



func _ready():
	projectile = preload("res://Entities/BulletGeneric.tscn")
	guncase = preload("res://Entities/ParticlesEffects/Particle_Guncase.tscn")
	
	
	name_string = "Sniper Rifle"
	gravity = 40
	handstate = 5
	
	ammo_in = 1
	ammo_size = 1
	ammo_out = 4
	
	auto_shoot = false
	auto_reload = true
	auto_refire = false
	
	flash_pos = $Flash.position.x
	$Flash.visible = false
	
	ground_frame = 2


#func set_flash_pos(): flash_pos = $Flash.position.x

func eject_case():
	var instance = guncase.instantiate()
	instance.position = position + Vector2(0,-6)
	instance.velocity = Vector2( (-100+randi()%50)*(holder.facing if holder else facing), -500 +randi()%200)
	instance.modulate = Color(1,1,0)
	instance.scale = Vector2(1.5, 0.75)
	get_parent().add_child(instance)



func shoot():
	if $Sprite.rotation_degrees >= 180: $Sprite.rotation_degrees = 180
	else: $Sprite.rotation_degrees = 0
	
	$Sfx.shoot()
	$Flash.flip_v = randi() % 2
	
	var instance = projectile.instantiate()
	
	instance.holder = holder
	instance.damage = 50
	instance.knockback = Vector2(-1000,0)
	instance.knock_replace = true
	instance.stun = 10
	instance.speed = 10000.0
	instance.dietime = 50.0
	instance.gravity = 0.0
	instance.deaccel = 0.0
	instance.scale.x = 3
	
	if holder:
		instance.add_collision_exception_with(holder)
		holder.velocity -= Vector2(450*facing,0)
		
	
	instance.facing = (holder.facing if holder else facing)
	instance.position = position + Vector2(55*(holder.facing if holder else facing),-6 * (-1 if ($Sprite.rotation_degrees >= 180) else 1))
	
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
