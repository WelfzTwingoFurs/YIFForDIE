extends AudioStreamPlayer2D

@export var audios: Array[String] = []

func _ready():
	var choose = randi()% audios.size()
	set_stream(load(audios[choose]))
