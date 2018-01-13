extends Area2D
var mothership
var activated = false
var ship_destroyed = 0
var y_shift = 30
const DELAY = 12
const VARIANCE = 5
var alarm_0 = 7 + randi()%VARIANCE
var hp = 45
var death = false
const SHIP_PATH = "res://instance/Bomber01.tscn"
var is_scoring = true
const HIT_SCORE = 100

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
	
	if mothership.current_stage > 0:
		activated = true
	
	if alarm_0 < 0:
		alarm_0 = DELAY + randi()%VARIANCE
		var ship_instance = preload(SHIP_PATH)
		var ship = ship_instance.instance()
		get_tree().get_root().add_child(ship)
		ship.fire_mode = 10
		ship.carrier = self
		ship.is_scoring = false
		ship.boss_fight = true
		var ship_pos = ship.get_pos()
		ship_pos.x = get_pos().x
		ship_pos.y = get_pos().y+30
		ship.set_pos(ship_pos)
		
	if hp < 0 and death == false:
		mothership.ship_destroyed += 1
		queue_free()
		death = true
