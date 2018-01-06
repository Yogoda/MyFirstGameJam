extends Node2D

const SHIP_Y_POS_MARGIN = 200 #final y position margin before the ship is destroyed
const VERTICAL_SPEED = 60
const HORIZONTAL_SPEED = 50
const X_MARGIN = 40 #edge limits
var up_direction = false
var down_direction = true
var left_direction = false
var right_direction = false
var carrier
# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	set_process(true)
	var i = randi()%2
	if i == 0:
		left_direction = true
	else:
		right_direction = true
	
func _process(delta):
	#step events
	var ship_pos = get_pos()
	
	#change direction if close to an edge
	if ship_pos.x < get_viewport_rect().pos.x + X_MARGIN:
		left_direction = false
		right_direction = true
	if ship_pos.x > get_viewport_rect().end.x - X_MARGIN:
		right_direction = false
		left_direction = true
	
	#movement
	if left_direction == true:
		ship_pos.x -= HORIZONTAL_SPEED * delta
	if right_direction == true:
		ship_pos.x += HORIZONTAL_SPEED * delta
	if up_direction == true:
		ship_pos.y -= VERTICAL_SPEED * delta
	if down_direction == true:
		ship_pos.y += VERTICAL_SPEED * delta

	set_pos(ship_pos) #apply new position
	
	#check if out of screen
	ship_pos = get_pos()
	
	if ship_pos.y > get_viewport_rect().end.y + SHIP_Y_POS_MARGIN:
		#inform carrier
		carrier.ship_destroyed += 1
			
		print("ship destroyed")
		#destroy ship
		queue_free()