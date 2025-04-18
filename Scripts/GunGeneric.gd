extends CharacterBody2D

var projectile = null
var magazine = null
var guncase = null

var name_string = "NULL :("
var gravity = 0
var ammo_in = 0
var ammo_out = 0
var ammo_size = 0
var flash_pos = 0

var auto_shoot = false  
var auto_reload = false
var auto_refire = false
var wait_shoot = false

var facing


var ground_frame = 0
var ground_frame2 = -1
var weight_divi = 1

#func _ready():
#	$AniPlay.stop()
#	$Sprite.frame = 0



var holder = null
var busy = false

var closers = []

func _physics_process(_delta):
	if holder == null:
		$Col.disabled = false
		move_and_slide()
		if !is_on_floor():
			velocity.y += gravity
			$Sprite.rotation_degrees += abs(Vector2().distance_to(velocity)/100)
			if $Sprite.rotation_degrees > 360: $Sprite.rotation_degrees = 0
		
		else:
			velocity.x = lerp(velocity.x, 0.0, 0.25)
			if $Sprite.rotation_degrees < 180: $Sprite.rotation = 0
			else: $Sprite.rotation_degrees = 180
	
	
	else:#holder
		$Col.disabled = true
		if !busy && holder.state != 0:
			if ammo_in:
				#if Input.is_action_just_pressed("shoot"+str(holder.player)) or (auto_shoot && (Input.is_action_just_pressed("shoot"+str(holder.player)) or (($AniPlay.current_animation != "shoot") && Input.is_action_pressed("shoot"+str(holder.player))))):
				if (!wait_shoot or (wait_shoot && $AniPlay.current_animation != "shoot")) && ( Input.is_action_just_pressed("shoot"+str(holder.player))    or    (auto_refire && Input.is_action_just_released("shoot"+str(holder.player)) && $AniPlay.current_animation == "shoot")    or    (auto_shoot && (Input.is_action_just_pressed("shoot"+str(holder.player)) or (($AniPlay.current_animation != "shoot") && Input.is_action_pressed("shoot"+str(holder.player))))) ):
					
					if Input.is_action_just_pressed("shoot"+str(holder.player)): close_check()
					if (holder.anibusy != 3) && (int(position.y - holder.position.y) < -10):
						#print(position,"  ",holder.position,"   ",position-holder.position)
						ammo_in -= 1
						holder.facing_input()
						$AniPlay.stop()
						$AniPlay.play("shoot")
					
					
					
					
			
				
				#elif (auto_refire && Input.is_action_just_released("shoot"+str(holder.player)) && $AniPlay.current_animation == "shoot"):
					#if ammo_in > 0:
						#ammo_in -= 1
						#$AniPlay.stop()
						#$AniPlay.play("shoot")
				
				
				
				
			elif ammo_out:
				#if ((auto_reload && Input.is_action_pressed("shoot"+str(holder.player))) or Input.is_action_just_pressed("shoot"+str(holder.player))):
				if (!wait_shoot or (wait_shoot && $AniPlay.current_animation != "shoot"))  &&  (auto_reload or Input.is_action_just_pressed("shoot"+str(holder.player))):
					
					#if $AniPlay.current_animation != "shoot":
					#	close_check()#condition so that it doesn't kick automatically late into the animationaa REMOVED/COMMENTED IT FOR THIS REASON TOO
					if holder.anibusy != 3:
						busy = true
						$AniPlay.play("reload")
					
					
				
			else:
				if ((auto_reload or auto_shoot) && Input.is_action_pressed("shoot"+str(holder.player))) or Input.is_action_just_pressed("shoot"+str(holder.player)):
					
					if Input.is_action_just_pressed("shoot"+str(holder.player)): close_check()
					if holder.anibusy != 3:
						$AniPlay.play("empty")
					
				
		
		
		
		#kick while reloading, deactivated cuz not sure why it will always kick when close??
		#elif busy && (holder.state != 0) && ($AniPlay.current_animation == "reload") && Input.is_action_just_pressed("shoot"+str(holder.player)):
		#	close_check()
	extra_physics_process()

func extra_physics_process():
	pass






func close_check():
	if closers.size(): if closers.has(holder): closers.erase(holder)
	for play in closers:#too close? melee!!
		if sign(play.position.x - holder.position.x) == holder.facing:
			holder.force_melee()
			break









var handstate = 1
func _process(_delta):
	if position.y > 2000: queue_free()
	
	facing = $Sprite.scale.x * (-1 if ($Sprite.rotation_degrees >= 180) else 1)
	
	
	if holder:
		if $AniPlay.current_animation == "reload": $AniPlay.speed_scale = 3
		elif !$AniPlay.is_playing() && (($Sprite.frame == ground_frame) or ($Sprite.frame == (ground_frame2 if (ground_frame2 != -1) else ground_frame))):
			$AniPlay.play("idle")
		
		
		if (holder.pos_onehanded[holder.frame] != null) && (holder.pos_onehanded[holder.frame] != Vector2(0,0)):
			match handstate:
				1: position = holder.position + (holder.pos_onehanded[holder.frame]*Vector2(holder.facing,1))
				2: position = holder.position + (holder.pos_reload[holder.frame]*Vector2(holder.facing,1))
				3: position = holder.position + (holder.pos_hip[holder.frame]*Vector2(holder.facing,1))
				4: position = holder.position + (holder.pos_hip[holder.frame]*Vector2(holder.facing,1))
				5: position = holder.position + (holder.pos_highaim[holder.frame]*Vector2(holder.facing,1))
				6: position = holder.position + (holder.pos_chaingun[holder.frame]*Vector2(holder.facing,1))
		
		#dposition = holder.position + (holder.pos_onehanded[holder.frame]*Vector2(holder.facing,1))
		velocity = Vector2(0,0)
		$Sprite.rotation_degrees = 0
		$Sprite.scale.x = holder.facing
		$Flash.scale.x  = holder.facing
		$Flash.position.x = flash_pos * holder.facing
		
		holder.set_handed(handstate)
		
	
	else:#not holder
		$Flash.visible = false
		
		if ammo_in + ammo_out <= 0:
			modulate = Color(0.5, 0.5, 0.5)
			$Sprite.frame = ground_frame2 if (ground_frame2 != -1) else ground_frame
		
		else:
			if $AniPlay.current_animation == "reload":
				$AniPlay.speed_scale = 0
				#if (ground_frame2 != -1): $Sprite.frame = ground_frame2
				$Sprite.frame = ground_frame2 if (ground_frame2 != -1) else ground_frame
			
			elif $AniPlay.current_animation != "shoot": $Sprite.frame = ground_frame
				
		
		
		if Input.is_action_just_pressed("bug_shoot"):
			$AniPlay.play("shoot")
		
		
		
	extra_process()

func extra_process():
	pass

#func set_handstate(valoo): handstate = valoo
#
#func set_busy(yeah): busy = yeah

func create_tag(): return (Time.get_ticks_usec()+int(name_string)+int($Flash.flip_v)+ammo_out)



func _on_too_close_body_exited(body):
	if closers.has(body):
		closers.erase(body)


func _on_too_close_body_entered(body):
	if body.is_in_group("player") && !closers.has(body):
		closers.push_back(body)
