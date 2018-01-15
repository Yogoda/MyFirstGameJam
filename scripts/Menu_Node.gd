extends Node

func _ready():

	if !Globals.has("music_level"):
		Globals.set("music_level", 0.5)
		Globals.set("sound_level", 0.5)
		Globals.set("difficulty",1) #0:easy, 1: normal, 2: hard
	pass
