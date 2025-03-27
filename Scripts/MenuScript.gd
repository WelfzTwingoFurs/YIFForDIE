extends Control

func _ready(): $Main/start.grab_focus()

func _process(_delta):
	start_process()
	player_process()
	rebinder_process()



####################################################################################################
   ######   #########      ###      #########   #########
   ###         ###      #########   ######         ###
######         ###      ###   ###   ###   ###      ###

var start_players = 2
var scene = null
func _on_start_pressed():
	$Main/start.release_focus()
	scene = load("res://Scenes/GameScene.tscn").instantiate()
	scene.players = start_players
	scene.skins = char_skins
	add_child(scene)

func start_process():
	if $Main/start.has_focus():
		$Main/start.text = "FIGHT! <" +str(start_players) +">"
		
		if    Input.is_action_just_pressed("menu_left"): start_players -= 1
		elif Input.is_action_just_pressed("menu_right"): start_players += 1
		if   start_players < 1: start_players = 4
		elif start_players > 4: start_players = 1
	
	#else:
	#	if Input.is_action_just_pressed("menu_no"):
	#		scene.queue_free()
	#		$Main/start.grab_focus()
####################################################################################################
####################################################################################################



####################################################################################################
######   #########   ######      #########   #########   #########   ###
###      ###   ###   ###   ###      ###      ######      ###   ###   ###
######   #########   ###   ###      ###      ###   ###   #########   ######

func _on_control_pressed():
	$Main/control.release_focus()
	steps = 0
	REBINDER = true

var actions = ["moveleft", "moveright", "moveup", "movedown", "jump", "grab", "shoot", "taunt"]
var REBINDER = false
var rebind_player = 1
var steps = 0

func _input(event): if REBINDER && event.is_released(): map_input(event)

func map_input(input):
	InputMap.action_erase_events(str(actions[steps]+str(rebind_player)))
	InputMap.action_add_event(str(actions[steps])+str(rebind_player), input)
	steps += 1

func rebinder_process():
	if REBINDER:
		if (steps >= actions.size()) or Input.is_action_just_pressed("menu_no"):
			$Main/control.grab_focus()
			steps = 0
			REBINDER = false
		
		else:
			$Main/control.text = actions[steps]+str(rebind_player) +"  [" +str(steps) +"/" +str(actions.size()) +"]"
	
	elif $Main/control.has_focus():
		$Main/control.text = "Control Setup <" +str(rebind_player) +">"
		
		if    Input.is_action_just_pressed("menu_left"): rebind_player -= 1
		elif Input.is_action_just_pressed("menu_right"): rebind_player += 1
		if   rebind_player < 1: rebind_player = 4
		elif rebind_player > 4: rebind_player = 1
		
####################################################################################################
####################################################################################################



####################################################################################################
#########   ###         ###      ###   ###   #########   #########
#########   ###      #########      ###      ######      ######
###         ######   ###   ###      ###      #########   ###   ###

func _on_player_pressed():
	$Main/player.release_focus()
	CHARACTER = true

var characters = ["res://Entities/PlayerStud/playerStud.tscn", "res://Entities/PlayerGaben/playerGaben.tscn"]
var char_skins = [0, 0, 0, 0]
var CHARACTER = false
var char_players = 1


func player_process():
	if CHARACTER:
		if Input.is_action_just_pressed("menu_no") or Input.is_action_just_pressed("menu_yes"):
			$Main/player.grab_focus()
			CHARACTER = false
		
		else:
			$Main/player.text = "Player " +str(char_players) +" skin: <" +load(characters[char_skins[char_players-1]]).instantiate().character_name +">"
			
			if    Input.is_action_just_pressed("menu_left"): char_skins[char_players-1] -= 1
			elif Input.is_action_just_pressed("menu_right"): char_skins[char_players-1] += 1
			if   char_skins[char_players-1] < 0: char_skins[char_players-1] = characters.size()-1
			elif char_skins[char_players-1] > characters.size()-1: char_skins[char_players-1] = 0
			
	
	
	
	elif $Main/player.has_focus():
		$Main/player.text = "Character Setup <" +str(char_players) +">"
		
		if    Input.is_action_just_pressed("menu_left"): char_players -= 1
		elif Input.is_action_just_pressed("menu_right"): char_players += 1
		if   char_players < 1: char_players = 4
		elif char_players > 4: char_players = 1
		
	
	
	
