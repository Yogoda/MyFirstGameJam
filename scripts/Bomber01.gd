extends Area2D

const SHIP_Y_POS_MARGIN = 200 #final y position margin before the ship is destroyed
const VERTICAL_SPEED = 60
const HORIZONTAL_SPEED = 50
const HIT_SCORE = 50
const KILL_SCORE = 250
const X_MARGIN = 40 #edge limits
const MISSILE_SPEED = 150
var ini = true
var carrier_informed = false
var up_direction = false
var down_direction = true
var left_direction = false
var right_direction = false
var carrier
var missile_angle = randi()%360
const MISSILE_ANGLE_SPEED = 80
var hp = 5
var death = false
var death_duration = 0.5
var fire_mode = 0 # 0 is 1 missile down, 1 is 4 missiles to the sides, 2 is 1 missile rotating around center, 3 is 4 missiles rotating around center
var fire1_rate = 0.8
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
	if ini == true:
		if fire_mode == 2:
			fire1_rate = 0.3
		if fire_mode == 3:
			fire1_rate = 0.4
		ini = false
	#update alarms
	fire1_alarm -= delta
	missile_angle += delta*MISSILE_ANGLE_SPEED
	if missile_angle >= 360:
		missile_angle = 0
		
	if fire1_alarm < 0:
		fire1_alarm = -1

	if death == true:
		death_duration -= delta
		get_node("25D Model/Model").explode()
		if death_duration < 0:
			queue_free()
		
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
		if carrier_informed == false:
			carrier.ship_destroyed += 1
			carrier_informed = true
			
		if hp < 1 and death == false:
			get_tree().get_root().get_node("World").get_node("Score").score += KILL_SCORE
			death = true
		
		#shooting
	if fire1_alarm < 0 and death == false:
		fire1_alarm = fire1_rate
		if fire_mode == 0:
			var missile = MISSILE_INSTANCE.instance()
			get_tree().get_root().add_child(missile)
			var missile_pos = missile.get_pos()
			missile_pos.x = ship_pos.x
			missile_pos.y = ship_pos.y + FIRE1_SHIFT
			missile.set_pos(missile_pos)
			missile.velocity = (Vector2(0,MISSILE_SPEED))
		elif fire_mode == 1:
			#spawn one missile to each sides
			var i
			for i in range(4):
				var missile = MISSILE_INSTANCE.instance()
				get_tree().get_root().add_child(missile)
				var missile_pos = missile.get_pos()
				if i == 0: #missile goes down
					missile_pos.x = ship_pos.x
					missile_pos.y = ship_pos.y + FIRE1_SHIFT
					missile.set_pos(missile_pos)
					missile.velocity = (Vector2(0,MISSILE_SPEED))
				if i == 1: #missile goes up
					missile_pos.x = ship_pos.x
					missile_pos.y = ship_pos.y - FIRE1_SHIFT
					missile.set_pos(missile_pos)
					missile.velocity = (Vector2(0,-MISSILE_SPEED))
				if i == 2: #missile goes left
					missile_pos.x = ship_pos.x - FIRE1_SHIFT
					missile_pos.y = ship_pos.y 
					missile.set_pos(missile_pos)
					missile.velocity = (Vector2(-MISSILE_SPEED,0))
				if i == 3: #missile goes right
					missile_pos.x = ship_pos.x + FIRE1_SHIFT
					missile_pos.y = ship_pos.y 
					missile.set_pos(missile_pos)
					missile.velocity = (Vector2(MISSILE_SPEED,0))
		elif fire_mode == 2:
			#spawn one missile rotating around axis
				var missile = MISSILE_INSTANCE.instance()
				get_tree().get_root().add_child(missile)
				var missile_pos = missile.get_pos()
				missile_pos.x = ship_pos.x
				missile_pos.y = ship_pos.y
				missile.set_pos(missile_pos)
				var norm_vector = Vector2(sin(deg2rad(missile_angle)),cos(deg2rad(missile_angle)))
				missile.velocity = (Vector2(norm_vector.x*MISSILE_SPEED,norm_vector.y*MISSILE_SPEED))
		elif fire_mode == 3:
			#rotating missiles from 4 directions - rotating. Hell yeah !!
			var i
			var new_angle = missile_angle
			for i in range(4):
				var missile = MISSILE_INSTANCE.instance()
				get_tree().get_root().add_child(missile)
				var missile_pos = missile.get_pos()
				missile_pos.x = ship_pos.x
				missile_pos.y = ship_pos.y
				missile.set_pos(missile_pos)
				new_angle += 90
				var norm_vector = Vector2(sin(deg2rad(new_angle)),cos(deg2rad(new_angle)))
				missile.velocity = (Vector2(norm_vector.x*MISSILE_SPEED,norm_vector.y*MISSILE_SPEED))
				