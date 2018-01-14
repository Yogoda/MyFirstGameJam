extends Node2D

var so_delay = 1.5
var entry_sound = true
var overmind
var vertical_speed = 30
var vertical_limit = 60
var down_direction = true
var ship_destroyed = 0
var stage_max = 4
var stage_terminated = false
var current_stage = 0
var ship_max = 8
var ship_num = 0
var alarm_0 = 0
var ini = false
const ALARM_DELAY = 1.0
const MAX_STAGE = 1
const HEAD_PATH = "res://instance/Boss/Boss_Head.tscn"
const CORE_PATH = "res://instance/Boss/Boss_Core.tscn"
const SILO_PATH = "res://instance/Boss/Boss_Silo.tscn"
const PLATFORM_PATH = "res://instance/Boss/Boss_Platform.tscn"
var y_shift = 30
var x_shift = 80

func _ready():

	set_process(true)
	
func _process(delta):
	if entry_sound == true:
		so_delay -= delta
		if so_delay < 0:
			so_delay = -1
	
	alarm_0 -= delta
	if alarm_0 < 0:
		alarm_0 = -1
	
	if ini == false:
		ini = true
		#SPAWN MOTHERSHIP PARTS
		var position = get_pos()
		#CORE
		var m_ship_core_instance = preload(CORE_PATH)
		var m_ship_core = m_ship_core_instance.instance()
		get_tree().get_root().add_child(m_ship_core)
		m_ship_core.set_pos(position)
		m_ship_core.mothership = self
		#HEAD
		var m_ship_head_instance = preload(HEAD_PATH)
		var m_ship_head = m_ship_head_instance.instance()
		get_tree().get_root().add_child(m_ship_head)
		position.y += 2*y_shift
		m_ship_head.set_pos(position)
		m_ship_head.mothership = self
		m_ship_head.y_shift = 2*y_shift
		#PLATFORMS
		for i in range(2):
			var m_ship_platform_instance = preload(PLATFORM_PATH)
			var m_ship_platform = m_ship_platform_instance.instance()
			get_tree().get_root().add_child(m_ship_platform)
			position = get_pos()
			position.y += y_shift
			if i == 0:
				position.x += x_shift
			else:
				position.x -= x_shift
			m_ship_platform.set_pos(position)
			m_ship_platform.mothership = self
			m_ship_platform.y_shift = y_shift
		#SILOS
		for i in range(2):
			var m_ship_silo_instance = preload(SILO_PATH)
			var m_ship_silo = m_ship_silo_instance.instance()
			get_tree().get_root().add_child(m_ship_silo)
			position = get_pos()
			position.y += 2*y_shift
			if i == 0:
				position.x += 2*x_shift
			else:
				position.x -= 2*x_shift
			m_ship_silo.set_pos(position)
			m_ship_silo.mothership = self
			m_ship_silo.y_shift = 2*y_shift
			

	if entry_sound == true:
		if so_delay < 0:
			#BOSS ENTRY SOUND
			var i = randi()%4
			var so_player = get_node("SoBossPlayer")
			var so_id = so_player.play("BossEntry")
			so_player.set_volume(so_id,Globals.get("sound_level"))
			entry_sound = false
	
	if down_direction == true:
		var position = get_pos()
		position.y += delta*vertical_speed
		if position.y > vertical_limit:
			down_direction = false
			alarm_0 = 1.0
		else:
			set_pos(position)
			if current_stage == 0:
				current_stage = 1
	
	if current_stage == 1 and ship_destroyed > 1:
		current_stage = 2
	if current_stage == 2 and ship_destroyed > 4:
		current_stage = 3
	if current_stage == 3 and ship_destroyed > 5:
		overmind.level_spawner_destroyed += 1
		queue_free()
