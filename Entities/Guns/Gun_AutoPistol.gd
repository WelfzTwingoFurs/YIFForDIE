extends "res://Scripts/GunGeneric.gd"



func _ready():
	#start_pos = position
	projectile = preload("res://Entities/BulletGeneric.tscn")
	magazine = preload("res://Entities/ParticlesEffects/Particle_Gunclip.tscn")
	guncase = preload("res://Entities/ParticlesEffects/Particle_Guncase.tscn")
	
	
	gravity = 30
	
	ammo_in = 6
	ammo_size = 6
	ammo_out = 18
	name_string = "Automatic Pistol"
	flash_pos = $Flash.position.x
	$Flash.visible = false
	
	auto_shoot = true
	auto_reload = true
	auto_refire = false
	
	ground_frame = 4
#func set_flash_pos(): flash_pos = $Flash.position.x

func eject_case():
	var instance = guncase.instantiate()
	instance.position = position + Vector2(0,-6)
	instance.velocity = Vector2( (-100+randi()%50)*(holder.facing if holder else facing), -500 +randi()%200)
	instance.modulate = Color(1,1,0)
	get_parent().add_child(instance)



func shoot():
	if $Sprite.rotation_degrees >= 180: $Sprite.rotation_degrees = 180
	else: $Sprite.rotation_degrees = 0
	
	$Sfx.shoot()
	$Flash.flip_v = randi() % 2
	
	var instance = projectile.instantiate()
	
	instance.holder = holder
	instance.damage = 15
	instance.knockback = Vector2(-250,-250)
	instance.knock_replace = false
	instance.stun = 10
	instance.speed = 3000.0
	instance.dietime = 20.0
	instance.gravity = 1.0
	instance.deaccel = 0.0
	instance.rotation_degrees = 359 +randi()%6
	instance.scale = Vector2(0.8,1)
	#instance.scale2 = Vector2(1.1,1.1)
	instance.facing = holder.facing if holder else facing
	
	
	
	if holder:
		instance.add_collision_exception_with(holder)
	instance.position = position + Vector2(0,-6 * (-1 if ($Sprite.rotation_degrees >= 180) else 1))
	get_parent().add_child(instance)

#func shoot():
	#$Sfx.shoot()
	#$Flash.flip_v = randi() % 2
	#
	#var instance = projectile.instantiate()
	#
	#instance.damage = 15
	#instance.knockback = Vector2(-250,-250)
	#instance.knock_replace = false
	#instance.stun = 10
	#instance.facing = 1
	#instance.speed = 3000.0
	#instance.dietime = 20.0
	#instance.gravity = 1.0
	#instance.deaccel = 0.0
	#
	#instance.facing = holder.facing
	#instance.position = position + Vector2(0,-6)
	#instance.add_collision_exception_with(holder)
	#get_parent().add_child(instance)





func release():
	$Sfx.release()
	ammo_in = 0
	
	var instance = magazine.instantiate()
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


