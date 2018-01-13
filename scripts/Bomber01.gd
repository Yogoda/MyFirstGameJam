extends Area2D

const SHIP_Y_POS_MARGIN = 200 #final y position margin before the ship is destroyed
var vertical_speed = 60
const HORIZONTAL_SPEED = 50
const HIT_SCORE = 50
const KILL_SCORE = 250
const X_MARGIN = 40 #edge limits
const MISSILE_SPEED = 150
const POWER_UP_DROP_RATE = 6
const SO_SHOOT_LVL = 0.3
var missle_1st_wave = false
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
var so_level = 0.5
var fire_mode = 0 # 0 is 1 missile down, 1 is 4 missiles to the sides, 2 is two missiles to the diagonals, 3 is 1 missile rotating around center, 4 is 4 missiles rotating around center
var fire1_rate = 0.8
const FIRE1_SHIFT = 20
var fire1_alarm = 0
var so_laser = "Laser_Shoot2"
const MISSILE_INSTANCE = preload("res://instance/missile_enemy.tscn")
const SHIP0_INSTANCE = preload("res://instance/Ships/Ship1.tscn")
const SHIP1_INSTANCE = preload("res://instance/Ships/Ship2.tscn")
const SHIP2_INSTANCE = preload("res://instance/Ships/Ship4.tscn")
const SHIP3_INSTANCE = preload("res://instance/Ships/Ship5.tscn")
const SHIP4_INSTANCE = preload("res://instance/Ships/Ship6.tscn")
const POWER_UP_INSTANCE = preload("res://instance/Power_Up.tscn")
# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	set_process(true)
	set_fixed_process(true)
	var i = randi()%2
	if i == 0:
		left_direction = true
	else:
		right_direction = true
	
func _fixed_process(delta):

	if death == false and (fire_mode == 3 or fire_mode == 4):
		rotate(0.1)
	
func _process(delta):
	
	if ini == true:
		so_level = get_tree().get_root().get_node("World").pub_sound_level
		if fire_mode == 0:
			var Model = SHIP0_INSTANCE.instance()
			get_node("25D Model").add_child(Model)
			hp = 5
			so_laser = "Laser_Shoot2"
			
		if fire_mode == 1:
			var Model = SHIP1_INSTANCE.instance()
			get_node("25D Model").add_child(Model)
			hp = 6
			so_laser = "Laser_Shoot9"
			
		if fire_mode == 2:
			var Model = SHIP2_INSTANCE.instance()
			get_node("25D Model").add_child(Model)
			left_direction = false
			right_direction = false
			hp = 10
			so_laser = "Laser_Shoot7"
			
		if fire_mode == 3:
			var Model = SHIP3_INSTANCE.instance()
			get_node("25D Model").add_child(Model)
			fire1_rate = 0.4
			hp = 8
			so_laser = "Laser_Shoot6"
			
		if fire_mode == 4:
			var Model = SHIP4_INSTANCE.instance()
			get_node("25D Model").add_child(Model)
			fire1_rate = 0.5
			hp = 7
			so_laser = "Laser_Shoot3"
			
		if fire_mode == 10:
			var Model = SHIP4_INSTANCE.instance()
			get_node("25D Model").add_child(Model)
			left_direction = false
			right_direction = false
			vertical_speed = 45
			fire1_rate = 2.0
			hp = 14
			so_laser = "Blip_Bomb"
			
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
		ship_pos.y -= vertical_speed * delta
	if down_direction == true:
		ship_pos.y += vertical_speed * delta

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
			#sound of explosion
			var i = randi()%4
			var so_player = get_node("SoPlayerDeath")
			var so_id = so_player.play("Explosion")
			if i == 0:
				so_id = so_player.play("Explosion")
			elif i == 1:
				so_id = so_player.play("Explosion3")
			elif i == 2:
				so_id = so_player.play("Explosion4")
			else:
				so_id = so_player.play("Explosion5")
			so_player.set_volume(so_id,so_level)
			
			i = randi()%POWER_UP_DROP_RATE
			if i == 0:
				#create a power up
				var power_up = POWER_UP_INSTANCE.instance()
				get_tree().get_root().add_child(power_up)
				var power_up_pos = power_up.get_pos()
				power_up_pos.x = ship_pos.x
				power_up_pos.y = ship_pos.y
				power_up.set_pos(power_up_pos)
				power_up.speed = vertical_speed
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
			#spawns one missile to each sides at front at a 90° angle
			var i
			for i in range(2):
				if i == 0:
					missile_angle = 335
				elif i == 1:
					missile_angle = 25
				var missile = MISSILE_INSTANCE.instance()
				get_tree().get_root().add_child(missile)
				var missile_pos = missile.get_pos()
				missile_pos.x = ship_pos.x
				missile_pos.y = ship_pos.y
				missile.set_pos(missile_pos)
				var norm_vector = Vector2(sin(deg2rad(missile_angle)),cos(deg2rad(missile_angle)))
				missile.velocity = (Vector2(norm_vector.x*MISSILE_SPEED,norm_vector.y*MISSILE_SPEED))
		elif fire_mode == 3:
			#spawn two missile rotating around axis
			var i
			var new_angle = missile_angle
			for i in range(2):
				if i == 1:
					new_angle = missile_angle + 180
				var missile = MISSILE_INSTANCE.instance()
				get_tree().get_root().add_child(missile)
				var missile_pos = missile.get_pos()
				missile_pos.x = ship_pos.x
				missile_pos.y = ship_pos.y
				missile.set_pos(missile_pos)
				var norm_vector = Vector2(sin(deg2rad(new_angle)),cos(deg2rad(new_angle)))
				missile.velocity = (Vector2(norm_vector.x*MISSILE_SPEED,norm_vector.y*MISSILE_SPEED))
				
		elif fire_mode == 4:
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
		elif fire_mode == 10:
			#suicide bombers
			if get_pos().y > get_viewport_rect().end.y - 100:
				if missle_1st_wave == false:
					missle_1st_wave = true
					var new_angle = 0
					for i in range(12):
						fire1_rate = 0.3
						fire1_alarm = fire1_rate
						new_angle = new_angle + 30
						var missile = MISSILE_INSTANCE.instance()
						get_tree().get_root().add_child(missile)
						var missile_pos = missile.get_pos()
						missile_pos.x = ship_pos.x
						missile_pos.y = ship_pos.y
						missile.set_pos(missile_pos)
						var norm_vector = Vector2(sin(deg2rad(new_angle)),cos(deg2rad(new_angle)))
						missile.velocity = (Vector2(norm_vector.x*MISSILE_SPEED,norm_vector.y*MISSILE_SPEED))
				else:
					var new_angle = 15
					for i in range(12):
						new_angle = new_angle + 30
						var missile = MISSILE_INSTANCE.instance()
						get_tree().get_root().add_child(missile)
						var missile_pos = missile.get_pos()
						missile_pos.x = ship_pos.x
						missile_pos.y = ship_pos.y
						missile.set_pos(missile_pos)
						var norm_vector = Vector2(sin(deg2rad(new_angle)),cos(deg2rad(new_angle)))
						missile.velocity = (Vector2(norm_vector.x*MISSILE_SPEED,norm_vector.y*MISSILE_SPEED))
						#ship is destroyed
						hp = 0
		#play sound
		ship_pos = get_pos()
		if ship_pos.y > get_viewport_rect().pos.y and ship_pos.y < get_viewport_rect().end.y :
			if missle_1st_wave == true:
				pass
			else:
				var so_player = get_node("Sounds")
				var so_id = so_player.play(so_laser)
				so_player.set_volume(so_id,SO_SHOOT_LVL*so_level)