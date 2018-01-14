extends Area2D
var active_check = false
var mothership
var activated = false
var activation_delay = 1
const HP_MAX = 70
var hp = HP_MAX
var death = false
var death_duration = 0.5
var is_scoring = true
const HIT_SCORE = 100
var fire1_rate = 1.2
var fire1_alarm = 0
const SPEED = 70
const SCREEN_MARGIN = 100
var up_direction = false
var down_direction = true
var left_direction = false
var right_direction = true
const MISSILE_SPEED = 150
const MISSILE_INSTANCE = preload("res://instance/missile_enemy.tscn")
var missile_angle = 0
var angle_increase = true
const MISSILE_ANGLE_SHIFT = 120
const MISSILE_DIRECTION_CHANGE = 300
var attack_stage = 1
const POWER_UP_INSTANCE = preload("res://instance/Power_Up.tscn")
var power_up_speed = 20

func _ready():
	set_process(true)

func _process(delta):
	if active_check == true and activated == false:
		activation_delay -= delta
		if activation_delay < 0:
			fire1_alarm = fire1_rate
			activated = true
		#alarms
	fire1_alarm -= delta
	if fire1_alarm < 0:
		fire1_alarm = -1
	
	var i = randi()%MISSILE_DIRECTION_CHANGE
	if i == 0:
		if angle_increase == true:
			angle_increase = false
		else:
			angle_increase = true
			
	if angle_increase == true:
		missile_angle += MISSILE_ANGLE_SHIFT*delta
		if missile_angle > 360:
			missile_angle -= 360
	else:
		missile_angle -= MISSILE_ANGLE_SHIFT*delta
		if missile_angle < 0:
			missile_angle += 360
	
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
			
	if hp < HP_MAX/2 and attack_stage == 1:
		attack_stage = 2
		fire1_rate = 0.1
			
	if hp < 0 and death == false:
		mothership.ship_destroyed += 1
		var player_ship = get_tree().get_root().get_node("Player")
		if player_ship != null:
			if player_ship.structure_points < player_ship.STRUCTURE_POINTS_MAX:
				#create a power up
				var position = get_pos()
				var power_up = POWER_UP_INSTANCE.instance()
				get_tree().get_root().add_child(power_up)
				var power_up_pos = power_up.get_pos()
				power_up_pos.x = position.x
				power_up_pos.y = position.y
				power_up.set_pos(power_up_pos)
				power_up.speed = power_up_speed
		#sound of explosion
		var so_player = get_node("SamplePlayer")
		var so_id = so_player.play("Explosion6")
		so_player.set_volume(so_id,get_tree().get_root().get_node("World").pub_sound_level)
		death = true
	
	if death == true:
		death_duration -= delta
		#get_node("25D Model/Model").explode()
		if death_duration < 0:
			queue_free()
			
	if active_check == false:
		if mothership.current_stage > 2:
			active_check = true
	
	if activated == true:
		if fire1_alarm < 0:
			fire1_alarm = fire1_rate
			var core_pos = get_pos()
			if attack_stage == 1:
				#Shooooooot missiles everywhere !!!!!!
				var new_angle = 0
				for i in range(18):
					new_angle += 20
					var missile = MISSILE_INSTANCE.instance()
					get_tree().get_root().add_child(missile)
					var missile_pos = missile.get_pos()
					missile_pos.x = core_pos.x
					missile_pos.y = core_pos.y
					missile.set_pos(missile_pos)
					var norm_vector = Vector2(sin(deg2rad(new_angle)),cos(deg2rad(new_angle)))
					missile.velocity = (Vector2(norm_vector.x*MISSILE_SPEED,norm_vector.y*MISSILE_SPEED))
				#sound of laser
				var so_player = get_node("LaserPlayer")
				var so_id = so_player.play("Laser_Shoot11")
				so_player.set_volume(so_id,get_tree().get_root().get_node("World").pub_sound_level)
					
			elif attack_stage == 2:
				var new_angle = 0
				for i in range(2):
					if i == 0:
						new_angle = missile_angle
					else:
						new_angle = missile_angle + 180
						
					var missile = MISSILE_INSTANCE.instance()
					get_tree().get_root().add_child(missile)
					var missile_pos = missile.get_pos()
					missile_pos.x = core_pos.x
					missile_pos.y = core_pos.y
					missile.set_pos(missile_pos)
					var norm_vector = Vector2(sin(deg2rad(new_angle)),cos(deg2rad(new_angle)))
					missile.velocity = (Vector2(norm_vector.x*MISSILE_SPEED,norm_vector.y*MISSILE_SPEED))
				#sound of laser
				var so_player = get_node("LaserPlayer")
				var so_id = so_player.play("Laser_Shoot12")
				so_player.set_volume(so_id,0.5*get_tree().get_root().get_node("World").pub_sound_level)
				
