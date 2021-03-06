extends Node2D

const SPEED = 400
var missile_speed = 500
var end_level = false
var up_direction = false
var down_direction = false
var left_direction = false
var right_direction = false
var alt_attack = false
var is_shooting = false
const SCREEN_MARGIN = 20
var position_initialize = true
var player_control = false
const PLAYER_Y_POS_START = 100 #x position afte which the player can take control
const PLAYER_Y_POS_INI = 200 #initial y position of the player out of screen
var structure_points = 3 
const STRUCTURE_POINTS_MAX = 5 #max level
var lives = 3
var invicible = true
var hit_invicible = false
var invici_counter = -1
const INVICI_COUNT = 0.5
const FIRE1_RATE = 0.22
const FIRE1_Y_SHIFT = 20
const FIRE2_RATE = 0.80
const FIRE2_X_SHIFT = 20
const FIRE3_RATE = 1.7
const FIRE3_X_SHIFT = 30
var fire1_alarm = 0
var fire2_alarm = 0
var fire3_alarm = 0
var death = false
var death_duration = 0.5
const MISSILE_INSTANCE = preload("res://instance/missile_player.tscn")

#const PLAYER_EXPL_1 = preload("res://instance/Ships/Explosions/Explosion1.tscn")
const PLAYER_EXPL_2 = preload("res://instance/Ships/Explosions/Explosion2.tscn")
const PLAYER_EXPL_3 = preload("res://instance/Ships/Explosions/Explosion3.tscn")
const PLAYER_EXPL_4 = preload("res://instance/Ships/Explosions/Explosion4.tscn")
const PLAYER_EXPL_5 = preload("res://instance/Ships/Explosions/Explosion5.tscn")

const SHIP_EXPLOSION = preload("res://instance/Ships/Ship Explosion.tscn")
const ALT_ATTACK_VISUAL_INSTANCE = preload("res://instance/AlternateAttack_visual.tscn")

var current_model

func set_invincible():
	
	hit_invicible = true
	invici_counter = INVICI_COUNT

func update_model():
	
	if current_model != null:
		current_model.set_hidden(true)
		current_model.enabled = false
		
	current_model = get_node("25D Model/" + String(structure_points))
	current_model.enabled = true

func upgrade(amnt):
	
	if structure_points < STRUCTURE_POINTS_MAX:
		structure_points += amnt
		update_model()
		set_invincible()
		return amnt
	
	return 0

func damage(dmg):
	
	if invicible == false and hit_invicible == false:

		if structure_points > 1:
			var explosion = SHIP_EXPLOSION.instance()
			add_child(explosion)
			
#			if structure_points == 1:
#				explosion.explode(PLAYER_EXPL_1)
			if structure_points == 2:
				explosion.explode(PLAYER_EXPL_2)
			if structure_points == 3:
				explosion.explode(PLAYER_EXPL_3)
			if structure_points == 4:
				explosion.explode(PLAYER_EXPL_4)
			if structure_points == 5:
				explosion.explode(PLAYER_EXPL_5)
						
		if structure_points > 3:#lose all power ups
			structure_points = 3
		else:
			structure_points -= dmg

		if structure_points > 0:
			#temporary invicibility if hit
			set_invincible()
			
			update_model()
			current_model.blink(4)
		
		return dmg
	
	return 0

func _ready():
	#initialize player position
	var player_pos = get_pos()
	player_pos.y = get_viewport_rect().end.y + PLAYER_Y_POS_INI
	player_pos.x = round(get_viewport_rect().end.x /2)
	set_pos(player_pos)
	up_direction = true
	
	update_model()
	
	#initialization
	set_process(true)
	set_process_input(true)
	
func _input(event):
	#controls
	if player_control == true and death == false:
		if event.is_action("ui_left"):
			left_direction = true
		if event.is_action_released("ui_left"):
			left_direction = false
			
		if event.is_action("ui_right"):
			right_direction = true
		if event.is_action_released("ui_right"):
			right_direction = false
			
		if event.is_action("ui_up"):
			up_direction = true
		if event.is_action_released("ui_up"):
			up_direction = false
			
		if event.is_action("ui_down"):
			down_direction = true
		if event.is_action_released("ui_down"):
			down_direction = false
			
		if event.is_action("ui_accept"):
			is_shooting = true
		if event.is_action_released("ui_accept"):
			is_shooting = false
			
		if event.is_action("ui_select"):
			alt_attack = true
		if event.is_action_released("ui_select"):
			alt_attack = false
				
func _process(delta):
	#update alarms
	fire1_alarm -= delta
	if fire1_alarm < 0:
		fire1_alarm = -1
		
	fire2_alarm -= delta
	if fire2_alarm < 0:
		fire2_alarm = -1
		
	fire3_alarm -= delta
	if fire3_alarm < 0:
		fire3_alarm = -1
		
	invici_counter -= delta
	if invici_counter <0:
		invici_counter = -1
		hit_invicible = false
	
	if death == true:
		death_duration -= delta
		if death_duration < 0:
			#communicate death to the overmind
			var overmind = get_tree().get_root().get_node("World").get_node("Overmind")
			overmind.player_destroyed = true
			queue_free()
	#end of level animation
	if end_level == true:
		player_control = false
		invicible = true
		left_direction = false
		right_direction = false
		up_direction = true
		down_direction = false
		var player_pos = get_pos()
		if player_pos.y < get_viewport_rect().pos.y - PLAYER_Y_POS_START:
			player_pos.y = get_viewport_rect().end.y + PLAYER_Y_POS_INI
			player_pos.x = round(get_viewport_rect().end.x /2)
			set_pos(player_pos)
			end_level = false
			position_initialize = true
		
	#step events
	var player_pos = get_pos()
	if left_direction == true:
		player_pos.x -= SPEED * delta
	if right_direction == true:
		player_pos.x += SPEED * delta
	if up_direction == true:
		player_pos.y -= SPEED * delta
	if down_direction == true:
		player_pos.y += SPEED * delta
	
	#Player must stay in scene
	if player_control == true:
		if player_pos.x + SCREEN_MARGIN > get_viewport_rect().end.x:
			player_pos.x = get_viewport_rect().end.x - SCREEN_MARGIN 
		if player_pos.y + SCREEN_MARGIN +30 > get_viewport_rect().end.y:
			player_pos.y = get_viewport_rect().end.y - SCREEN_MARGIN -30
		if player_pos.x < get_viewport_rect().pos.x + SCREEN_MARGIN:
			player_pos.x = get_viewport_rect().pos.x + SCREEN_MARGIN
		if player_pos.y < get_viewport_rect().pos.y + SCREEN_MARGIN:
			player_pos.y = get_viewport_rect().pos.y + SCREEN_MARGIN
		
	else:
		if position_initialize == true:
			if player_pos.y < get_viewport_rect().end.y - PLAYER_Y_POS_START:
				up_direction = false
				player_control = true
				invicible = false
				#temporary invicibility "wow that's a lot of i's! but I think indivisibility beats it :P
				set_invincible()
				
	set_pos(player_pos)
	
	#shooting
	if player_control == true and death == false:
		if is_shooting == true:
			player_pos = get_pos()
			if fire1_alarm < 0:
				fire1_alarm = FIRE1_RATE
				var missile = MISSILE_INSTANCE.instance()
				get_tree().get_root().add_child(missile)
#				add_child(missile)
				var missile_pos = missile.get_pos()
				missile_pos.x = player_pos.x
				missile_pos.y = player_pos.y - FIRE1_Y_SHIFT
				missile.set_pos(missile_pos)
				missile.play_sound(missile.MISSILE_TYPE_1)
				
			if structure_points > 3 and fire2_alarm <0:
				fire2_alarm = FIRE2_RATE
				#secondary fire mode enabled !
				var i
				for i in range(2):
					var missile_angle = 0
					if i == 0:
						missile_angle = 355
					elif i == 1:
						missile_angle = 5
					var missile = MISSILE_INSTANCE.instance()
					get_tree().get_root().add_child(missile)
					var missile_pos = missile.get_pos()
					if i == 0:
						missile_pos.x = player_pos.x - FIRE2_X_SHIFT
					else:
						missile_pos.x = player_pos.x + FIRE2_X_SHIFT
					missile_pos.y = player_pos.y - FIRE1_Y_SHIFT
					missile.set_pos(missile_pos)
					var norm_vector = Vector2(sin(deg2rad(missile_angle)),-cos(deg2rad(missile_angle)))
					missile.velocity = (Vector2(norm_vector.x*missile_speed,norm_vector.y*missile_speed))
					#play sound
					missile.play_sound(missile.MISSILE_TYPE_2)
			if structure_points > 4 and fire3_alarm <0:
				fire3_alarm = FIRE3_RATE
				#tertiary fire mode enabled !!!!
				var i
				for i in range(2):
					var missile_angle = 0
					var new_missile_speed = round(2*missile_speed/3)
					if i == 0:
						missile_angle = 315
					elif i == 1:
						missile_angle = 45
					var missile = MISSILE_INSTANCE.instance()
					get_tree().get_root().add_child(missile)
					var missile_pos = missile.get_pos()
					if i == 0:
						missile_pos.x = player_pos.x - FIRE3_X_SHIFT
					else:
						missile_pos.x = player_pos.x + FIRE3_X_SHIFT
					missile_pos.y = player_pos.y
					missile.set_pos(missile_pos)
					if i == 0:
						var norm_vector = Vector2(sin(deg2rad(missile_angle)),-cos(deg2rad(missile_angle)))
						missile.velocity = (Vector2(norm_vector.x*new_missile_speed,norm_vector.y*new_missile_speed))
					else:
						var norm_vector = Vector2(-sin(deg2rad(missile_angle)),-cos(deg2rad(missile_angle)))
						missile.velocity = (Vector2(norm_vector.x*new_missile_speed,norm_vector.y*new_missile_speed))
					missile.mad_dog_mode = true
					if i == 0:
						missile.amp_up= true
					else:
						missile.amp_up= false
					#play sound
					missile.play_sound(missile.MISSILE_TYPE_3)
	#Alternative attack
	if alt_attack == true:
		var alt_bar = get_tree().get_root().get_node("World").get_node("AlternateAttack").get_node("ProgressBar")
		if alt_bar.get_value() ==alt_bar.get_max():
			var so_player = get_tree().get_root().get_node("World").get_node("SoPlayerEvents")
			var so_id = so_player.play("AltAttack")
			so_player.set_volume(so_id,Globals.get("sound_level"))
			alt_bar.set_value(0)
			#visual
			var alt_attack_visual = ALT_ATTACK_VISUAL_INSTANCE.instance()
			get_tree().get_root().add_child(alt_attack_visual)
			alt_attack_visual.set_pos(Vector2(get_pos().x,get_pos().y))
			
			
	if structure_points < 1 and death == false:
		up_direction = false
		down_direction = false
		left_direction = false
		right_direction = false
		var so_player = get_tree().get_root().get_node("World").get_node("SoPlayerDeath")
		var so_id = so_player.play("Explosion2")
		so_player.set_volume(so_id,Globals.get("sound_level"))
		current_model.explode()
		death = true
		
