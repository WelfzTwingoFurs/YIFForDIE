extends "res://Scripts/GunGeneric.gd"



func _ready():
	handstate = 6
	projectile = preload("res://Entities/BulletGeneric.tscn")
	guncase = preload("res://Entities/ParticlesEffects/Particle_Guncase.tscn")
	gravity = 85
	ammo_in = 50
	ammo_size = 0
	ammo_out = 0
	name_string = "Chaingun"
	flash_pos = $Flash.position.x
	$Flash.visible = false
	auto_shoot = true
	auto_reload = false
	auto_refire = false
	ground_frame = 2
	weight_divi = 1.25

func eject_case():
	var instance = guncase.instantiate()
	instance.position = position + Vector2(-25*facing,-6)
	instance.velocity = Vector2( (-100+randi()%50)*(holder.facing if holder else facing), -500 +randi()%200)
	instance.modulate = Color(1,1,0)
	get_parent().add_child(instance)




func try_shoot():
	if $AniPlay.speed_scale > 2.5:
		shoot()
		eject_case()

func extra_physics_process():
	if ($AniPlay.speed_scale > 0) && (!holder or !Input.is_action_pressed("shoot"+str(holder.player))):
		$AniPlay.play("release")
		if holder && Input.is_action_just_released("shoot"+str(holder.player)) && ($AniPlay.speed_scale > 1.5):
			$Sfx.release()
	
	elif holder && Input.is_action_just_pressed("shoot"+str(holder.player)):
		$Sfx.charge()
	
	
	if (!holder or !Input.is_action_pressed("shoot"+str(holder.player))):
		$AniPlay.speed_scale = lerp($AniPlay.speed_scale, 0.0, 0.05)
		weight_divi = lerp(weight_divi, 1.25, 0.05)
		
	elif Input.is_action_pressed("shoot"+str(holder.player)):
		$AniPlay.speed_scale = lerp($AniPlay.speed_scale, 3.0, 0.05)
		weight_divi = lerp(weight_divi, 2.0, 0.05)





func shoot():
	if $Sprite.rotation_degrees >= 180: $Sprite.rotation_degrees = 180
	else: $Sprite.rotation_degrees = 0
	
	$Sfx.shoot()
	$Flash.visible = true
	$Flash.flip_v = randi() % 2
	
	var instance = projectile.instantiate()
	
	instance.holder = holder
	instance.damage = 7.5
	instance.knockback = Vector2(-100,0)
	instance.knock_replace = false
	instance.stun = 3
	instance.speed = 4000.0
	instance.dietime = 10.0
	instance.gravity = 0.0
	instance.deaccel = 0.0
	instance.rotation_degrees = 345 +randi()%30
	instance.scale = Vector2(1,1.25)
	instance.facing = holder.facing if holder else facing
	
	if holder:
		instance.add_collision_exception_with(holder)
	instance.position = position + Vector2(75*facing,5)
	get_parent().add_child(instance)









#func release():
	#$Sfx.release()
	#ammo_in = 0
	#
	#var instance = magazine.instantiate()
	#instance.position = position + Vector2(-12*(holder.facing if holder else facing),0)
	#instance.velocity = velocity
	#get_parent().add_child(instance)
#
#func reload():
	#$Sfx.reload()
	#if ammo_out > ammo_size:
		#ammo_in = ammo_size
		#ammo_out -= ammo_size
	#else:
		#ammo_in = ammo_out
		#ammo_out = 0
#
#func set_handstate(valoo): handstate = valoo
#
#func set_busy(yeah): busy = yeah
