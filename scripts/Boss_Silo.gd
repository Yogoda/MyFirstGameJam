extends Area2D
var mothership
var activated = false
var y_shift = 30
var ship_destroyed = 0
var alarm_0 = 7
var hp = 100
const DELAY = 8
const SHIP_PATH = "res://instance/Bomber01.tscn"

func _ready():
	set_process(true)

func _process(delta):
	alarm_0 -= delta
	if alarm_0 < 0:
		alarm_0 = -1
		
	var position = get_pos()
	var m_position = mothership.get_pos()
	position.y = m_position.y + y_shift
	set_pos(position)
	
	if alarm_0 < 0:
		alarm_0 = DELAY
		var ship_instance = preload(SHIP_PATH)
		var ship = ship_instance.instance()
		get_tree().get_root().add_child(ship)
		ship.fire_mode = 10
		ship.carrier = self
		var ship_pos = ship.get_pos()
		ship_pos.x = get_pos().x
		ship_pos.y = get_pos().y+30
		ship.set_pos(ship_pos)

