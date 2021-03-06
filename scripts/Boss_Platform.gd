extends Area2D
var mothership
var activated = false
var y_shift = 30
var ship_destroyed = 0
const DELAY = 14
const VARIANCE = 4
var alarm_0 = 12 + randi()%VARIANCE
var hp = 1 #45
var death = false
var death_duration = 0.5
const SHIP_PATH = "res://instance/Bomber01.tscn"
const POWER_UP_INSTANCE = preload("res://instance/Power_Up.tscn")
var power_up_speed = 20
var is_scoring = true
const HIT_SCORE = 100

func _ready():
	var difficulty = Globals.get("difficulty")
	if difficulty == 0:
		hp = 30
	elif difficulty == 1:
		hp = 45
	elif difficulty == 2:
		hp = 60
	set_process(true)

func _process(delta):
	alarm_0 -= delta
	if alarm_0 < 0:
		alarm_0 = -1
		
	var position = get_pos()
	var m_position = mothership.get_pos()
	position.y = m_position.y + y_shift
	set_pos(position)
	
	if mothership.current_stage > 0:
		activated = true

	if alarm_0 < 0:
		alarm_0 = DELAY + randi()%VARIANCE
		var ship_instance = preload(SHIP_PATH)
		var ship = ship_instance.instance()
		get_tree().get_root().add_child(ship)
		ship.fire_mode = 4
		ship.carrier = self
		ship.is_scoring = false
		ship.boss_fight = true
		var ship_pos = ship.get_pos()
		ship_pos.x = get_pos().x
		ship_pos.y = get_pos().y+30
		ship.set_pos(ship_pos)
		
	if hp < 1 and death == false:
		get_node("25D Model/Model").explode()
		mothership.ship_destroyed += 1
		#create a power up!
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
		so_player.set_volume(so_id,Globals.get("sound_level"))
		death = true
		
	if death == true:
		death_duration -= delta
		if death_duration < 0:
			queue_free()

