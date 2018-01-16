extends Node

func _ready():

	if !Globals.has("music_level"):
		print("set globals")
		Globals.set("music_level", 0.1)
		Globals.set("sound_level", 0.1)
		Globals.set("difficulty",1) #0:easy, 1: normal, 2: hard
	pass
