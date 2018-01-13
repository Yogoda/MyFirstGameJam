extends Area2D
var mothership
var activated = false
var y_shift = 30
var hp = 200

func _ready():
	set_process(true)

func _process(delta):
	var position = get_pos()
	var m_position = mothership.get_pos()
	position.y = m_position.y + y_shift
	set_pos(position)