extends Area2D
var mothership
var activated = false
var hp = 300

func _ready():
	set_process(true)

func _process(delta):
	var position = mothership.get_pos()
	set_pos(position)
	

