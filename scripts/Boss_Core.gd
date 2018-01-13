extends Area2D
var active_check = false
var mothership
var activated = false
var hp = 75
var death = false
var is_scoring = true
const HIT_SCORE = 100
var fire1_rate = 1.0
var fire1_alarm = 0
const SPEED = 80
const SCREEN_MARGIN = 100
var up_direction = false
var down_direction = true
var left_direction = false
var right_direction = true

func _ready():
	set_process(true)

func _process(delta):
		#alarms
	fire1_alarm -= delta
	if fire1_alarm < 0:
		fire1_alarm = -1
	
	#movement
	if activated == false:
		var position = mothership.get_pos()
		set_pos(position)
	else:
		var position = get_pos()
		if left_direction == true:
			position.x -= SPEED * delta
		if right_direction == true:
			position.x += SPEED * delta
		if up_direction == true:
			position.y -= SPEED * delta
		if down_direction == true:
			position.y += SPEED * delta
			
		if position.x + SCREEN_MARGIN > get_viewport_rect().end.x:
			position.x = get_viewport_rect().end.x - SCREEN_MARGIN
			right_direction = false
			left_direction = true
		if position.y + SCREEN_MARGIN +30 > get_viewport_rect().end.y:
			position.y = get_viewport_rect().end.y - SCREEN_MARGIN -30
			up_direction = true
			down_direction = false
		if position.x < get_viewport_rect().pos.x + SCREEN_MARGIN:
			position.x = get_viewport_rect().pos.x + SCREEN_MARGIN
			right_direction = true
			left_direction = false
		if position.y < get_viewport_rect().pos.y + SCREEN_MARGIN:
			position.y = get_viewport_rect().pos.y + SCREEN_MARGIN
			up_direction = false
			down_direction = true
			
		set_pos(position)
			
	if hp < 0 and death == false:
		mothership.ship_destroyed += 1
		queue_free()
		death = true

	if active_check == false:
		if mothership.current_stage > 2:
			fire1_alarm = 2*fire1_rate
			active_check = true
			activated = true