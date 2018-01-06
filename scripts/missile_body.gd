extends KinematicBody2D

const SPEED = 500
const SCREEN_MARGIN = 20

var up_direction = true
var down_direction = false
var left_direction = false
var right_direction = false

var destroy = false

func _ready():
	set_process(true)

func _process(delta):
	var body = get_collider()
	if body != null:
		if body.is_in_group("enemy"):
			body.hp -= 1
			destroy= true
		
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
	if missile_pos.x < get_viewport_rect().pos.x - SCREEN_MARGIN:
		destroy = true
	if missile_pos.x > get_viewport_rect().end.x + SCREEN_MARGIN:
		destroy = true
	if missile_pos.y < get_viewport_rect().pos.y - SCREEN_MARGIN:
		destroy = true
	if missile_pos.y > get_viewport_rect().end.y + SCREEN_MARGIN:
		destroy = true
	print (destroy)
	
	if destroy == true:
		print("fizzz")
		queue_free()
