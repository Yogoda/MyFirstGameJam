extends Area2D

const SPEED = 500
const SCREEN_MARGIN = 20
const ALARM_CHECK = 0.2
var alarm_0 = ALARM_CHECK
var up_direction = true
var down_direction = false
var left_direction = false
var right_direction = false

var destroy = false

func _ready():
	set_process(true)

func _process(delta):
	alarm_0 -= delta
	
	if alarm_0 < 0:
		connect("area_enter",self,"_on_area_enter")
		alarm_0 = ALARM_CHECK
		
	#step events
	var missile_pos = get_pos()
	
	if left_direction == true:
		missile_pos.x -= SPEED * delta
	if right_direction == true:
		missile_pos.x += SPEED * delta
	if up_direction == true:
		missile_pos.y -= SPEED * delta
	if down_direction == true:
		missile_pos.y += SPEED * delta
		
	set_pos(missile_pos)
		
	#destroy if out of game range
	
	missile_pos = get_pos()
	
	if missile_pos.x < get_viewport_rect().pos.x - SCREEN_MARGIN:
		destroy = true
	if missile_pos.x > get_viewport_rect().end.x + SCREEN_MARGIN:
		destroy = true
	if missile_pos.y < get_viewport_rect().pos.y - SCREEN_MARGIN:
		destroy = true
	if missile_pos.y > get_viewport_rect().end.y + SCREEN_MARGIN:
		destroy = true
	
	if destroy == true:
		queue_free()

func _on_area_enter(other):
	if other.is_in_group("enemy"):
		other.hp -= 1
		get_tree().get_root().get_node("World").get_node("Score").score += other.HIT_SCORE
		queue_free()
