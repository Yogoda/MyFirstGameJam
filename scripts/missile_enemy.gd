extends Area2D

const SPEED = 500
const SCREEN_MARGIN = 20

var destroy = false
var velocity = Vector2(0,200)
const ALARM_CHECK = 0.2
var alarm_0 = ALARM_CHECK

func _ready():
	set_process(true)

func _process(delta):
	alarm_0 -= delta
	if alarm_0 < 0:
		connect("area_enter",self,"_on_area_enter")
		alarm_0 = ALARM_CHECK

	#step events

	var missile_pos = get_pos()
	
	missile_pos.x += velocity.x * delta
	missile_pos.y += velocity.y * delta
	
	#destroy if out of game range
	if missile_pos.x < get_viewport_rect().pos.x - SCREEN_MARGIN:
		destroy = true
	if missile_pos.x > get_viewport_rect().end.x + SCREEN_MARGIN:
		destroy = true
	if missile_pos.y < get_viewport_rect().pos.y - SCREEN_MARGIN:
		destroy = true
	if missile_pos.y > get_viewport_rect().end.y + SCREEN_MARGIN:
		destroy = true
	
	set_pos(missile_pos)
	
	if destroy == true:
		print("fizzz")
		queue_free()

func _on_area_enter(other):

	if other.is_in_group("player"):
		if other.invicible == false:
			other.structure_points -= 1
			queue_free()
		print("splatt")
		