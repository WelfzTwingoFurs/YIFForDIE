extends Node2D

var GAME_ON = true
var players = 2

func _process(_delta):
	if GAME_ON:
		if players != 1:
			var deads = 0
			for p in gamers:
				if p.HP < -199: deads += 1
				#print(p.dead)
			
			
			if deads >= players-1:
				prepare_round()
				deads = 0
		
		elif gamers[0].HP < -199: prepare_round()



func _ready(): prepare_round()

func prepare_round():
	if scenario != null: scenario.queue_free()
	scenario = scenes[randi() % scenes.size()].instantiate()
	scenario.spawnpoints.shuffle()
	add_child(scenario)
	
	
	cam = camera.instantiate()
	cam.limit = scenario.limit
	cam.edges = scenario.edges
	scenario.add_child(cam)
	
	gamers = []
	
	if players != 1:
		cam.focus = -1
		var playcount = players
		while playcount > 0:
			#var playernow = player.instantiate()
			var playernow = characters[skins[playcount-1]].instantiate()
			playernow.player = playcount
			playernow.position = scenario.spawnpoints[int(playcount) % scenario.spawnpoints.size()]
			playernow.position.x += playcount
			playernow.low_limit = scenario.edges.w
			gamers.push_back(playernow)
			scenario.add_child(playernow)
			playcount -= 1
	
	
	else:
		cam.focus = 1
		#var playernow = player.instantiate()
		var playernow = characters[skins[0]].instantiate().instantiate()
		playernow.player = 1
		playernow.position = scenario.spawnpoints[players-1]
		playernow.low_limit = scenario.edges.w
		gamers.push_back(playernow)
		scenario.add_child(playernow)

var scenario = null
var cam = null
var gamers = []

var scenes = [preload("res://Levels/level2.tscn"), preload("res://Levels/level1.tscn"), preload("res://Levels/level_test.tscn")]
var player = preload("res://Entities/PlayerStud/playerStud.tscn")
var camera = preload("res://Entities/camera.tscn")

var characters = [preload("res://Entities/PlayerStud/playerStud.tscn"), preload("res://Entities/PlayerGaben/playerGaben.tscn")]
var skins = [0, 0, 0, 0]
