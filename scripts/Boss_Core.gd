extends Area2D
var mothership
var activated = false
var hp = 300
var death = false
const HIT_SCORE = 100

func _ready():
	set_process(true)

func _process(delta):
	var position = mothership.get_pos()
	set_pos(position)
	
	if hp < 0 and death == false:
		mothership.ship_destroyed += 1
		queue_free()
		death = true
