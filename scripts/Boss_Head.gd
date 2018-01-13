extends Area2D
var mothership
var activated = false
var active_check = false
var y_shift = 30
var hp = 75
var death = false
var is_scoring = true
const HIT_SCORE = 100
var fire1_rate = 1.0
var fire1_alarm = 0
var missile_angle = 60
var angle_increase = true
const MISSILE_ANGLE_SHIFT = 15
const MISSILE_SPEED = 150
const MISSILE_INSTANCE = preload("res://instance/missile_enemy.tscn")

func _ready():
	set_process(true)

func _process(delta):
	#alarms
	fire1_alarm -= delta
	if fire1_alarm < 0:
		fire1_alarm = -1
	
	var position = get_pos()
	var m_position = mothership.get_pos()
	position.y = m_position.y + y_shift
	set_pos(position)
	
	if active_check == false:
		if mothership.current_stage > 1:
			fire1_alarm = 2*fire1_rate
			active_check = true
			activated = true

	if hp < 0 and death == false:
		mothership.ship_destroyed += 1
		queue_free()
		death = true
	
	if activated == true:
		if fire1_alarm < 0:
			fire1_alarm = fire1_rate
			#Shooooooot !!!!
			var new_angle = missile_angle - 2*MISSILE_ANGLE_SHIFT
			
			var head_pos = get_pos()
			for i in range(5):
				var new_missile_angle = new_angle + i*MISSILE_ANGLE_SHIFT
				var missile = MISSILE_INSTANCE.instance()
				get_tree().get_root().add_child(missile)
				var missile_pos = missile.get_pos()
				missile_pos.x = head_pos.x
				missile_pos.y = head_pos.y
				missile.set_pos(missile_pos)
				var norm_vector = Vector2(sin(deg2rad(new_missile_angle)),cos(deg2rad(new_missile_angle)))
				missile.velocity = (Vector2(norm_vector.x*MISSILE_SPEED,norm_vector.y*MISSILE_SPEED))
				
			if angle_increase == true:
				missile_angle += MISSILE_ANGLE_SHIFT
				if missile_angle >= 60:
					angle_increase = false
			else:
				missile_angle -= MISSILE_ANGLE_SHIFT
				if missile_angle <= -60:
					angle_increase = true