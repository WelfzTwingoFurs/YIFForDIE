extends AudioStreamPlayer2D

var attack1 = preload("res://Assets/PlayerGaben/attack.wav")
func attack():
	set_stream(attack1)
	play()

var ouch1 = preload("res://Assets/PlayerGaben/ouch.wav")
func ouch():
	set_stream(ouch1)
	play()

var die1 = preload("res://Assets/PlayerGaben/die.wav")
func die():
	set_stream(die1)
	play()

var taunt1 = preload("res://Assets/PlayerGaben/taunt.wav")
func taunt():
	set_stream(taunt1)
	play()
