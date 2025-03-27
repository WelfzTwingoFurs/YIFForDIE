extends "res://Scripts/GunGeneric.gd"



func _ready():
	projectile = preload("res://Entities/BulletGeneric.tscn")
	guncase = preload("res://Entities/ParticlesEffects/Particle_Guncase.tscn")
	
	
	gravity = 30
	
	ammo_in = 6
	ammo_size = 6
	ammo_out = 18
	name_string = "Magnum Revolver"
	flash_pos = $Flash.position.x
	$Flash.visible = false
	
	auto_shoot = false
	auto_reload = false
	auto_refire = false
	wait_shoot = true
	
	ground_frame = 3

#func set_flash_pos(): flash_pos = $Flash.position.x

func eject_case():
	var instance = guncase.instantiate()
	instance.position = position + Vector2(0,-6)
	instance.velocity = Vector2( (-150-randi()%50)*(holder.facing if holder else facing), -30 -randi()%20)
	instance.modulate = Color(1,0.5,0)
	instance.scale = Vector2(0.5, 0.5)
	get_parent().add_child(instance)



func shoot():
	if $Sprite.rotation_degrees >= 180: $Sprite.rotation_degrees = 180
	else: $Sprite.rotation_degrees = 0
	
	$Sfx.shoot()
	$Flash.flip_v = randi() % 2
	
	var instance = projectile.instantiate()
	
	instance.holder = holder
	instance.damage = 35
	instance.knockback = Vector2(-500,-500)
	instance.knock_replace = false
	instance.stun = 20
	instance.speed = 5000.0
	instance.dietime = 15.0
	instance.gravity = 1.0
	instance.deaccel = 0.0
	instance.rotation_degrees = 359 +randi()%3
	instance.scale = Vector2(1.5, 1)
	instance.facing = holder.facing if holder else facing
	
	
	
	if holder:
		holder.velocity -= Vector2(250*facing,50)
		
		instance.add_collision_exception_with(holder)
	
	instance.position = position + Vector2(10*(holder.facing if holder else facing), -10 * (-1 if ($Sprite.rotation_degrees >= 180) else 1))
	get_parent().add_child(instance)




func release():
	$Sfx.release()
	ammo_in = 0
	
	for b in ammo_size:
		eject_case()

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


