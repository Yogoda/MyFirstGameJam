extends Area2D
var mothership
var activated = false
var y_shift = 30
var hp = 200
var death = false
const HIT_SCORE = 100

func _ready():
	set_process(true)

func _process(delta):
	var position = get_pos()
	var m_position = mothership.get_pos()
	position.y = m_position.y + y_shift
	set_pos(position)
	
	if hp < 0 and death == false:
		mothership.ship_destroyed += 1
		queue_free()
		death = true