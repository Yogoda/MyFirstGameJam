extends Area2D

const SHIP_Y_POS_MARGIN = 200 #final y position margin before the ship is destroyed
const VERTICAL_SPEED = 60
const HORIZONTAL_SPEED = 50
const HIT_SCORE = 50
const KILL_SCORE = 250
const X_MARGIN = 40 #edge limits
const MISSILE_SPEED = 200
var up_direction = false
var down_direction = true
var left_direction = false
var right_direction = false
var carrier
var hp = 5
const FIRE1_RATE = 0.7
const FIRE1_SHIFT = 20
var fire1_alarm = 0
const MISSILE_INSTANCE = preload("res://instance/missile_enemy.tscn")
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
	#update alarms
	fire1_alarm -= delta
	if fire1_alarm < 0:
		fire1_alarm = -1
		
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
	
	if ship_pos.y > get_viewport_rect().end.y + SHIP_Y_POS_MARGIN or hp < 1:
		#inform carrier
		carrier.ship_destroyed += 1
			
		if hp < 1:
			get_tree().get_root().get_node("World").get_node("Score").score += KILL_SCORE
		#destroy ship
		queue_free()
		
		#shooting
	if fire1_alarm < 0:
		fire1_alarm = FIRE1_RATE
		var missile = MISSILE_INSTANCE.instance()
		get_tree().get_root().add_child(missile)
		var missile_pos = missile.get_pos()
		missile_pos.x = ship_pos.x
		missile_pos.y = ship_pos.y + FIRE1_SHIFT
		missile.set_pos(missile_pos)
		missile.velocity = (Vector2(0,MISSILE_SPEED))