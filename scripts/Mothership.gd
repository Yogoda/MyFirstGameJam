extends Node2D

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
#		var i
#		var xpos_ini = 0
#		var x_shift = 40
#		var ship_stage = 0
#		xpos_ini = x_shift
#		for i in range(8):
#			var ship = ship_instance.instance()
#			get_tree().get_root().add_child(ship)
#			ship.fire_mode = 10
#			ship.activated = false
#			ship.carrier = self
#			var ship_pos = ship.get_pos()
#			ship_pos.y = get_pos().y
#			if i%2 == 0:
#				xpos_ini += x_shift
#				ship_stage += 1
#				ship_pos.x = get_pos().x + xpos_ini
#			else:
#				ship_pos.x = get_pos().x - xpos_ini
#			ship.carrier_y_shift = round(xpos_ini/2)
#			ship.boss_stage = ship_stage
#			ship.set_pos(ship_pos)
	
	if down_direction == true:
		var position = get_pos()
		position.y += delta*vertical_speed
		if position.y > vertical_limit:
			down_direction = false
			alarm_0 = 1.0
		else:
			set_pos(position)
#	else:
#		if alarm_0 <0:
#			if current_stage < stage_max:
#				if current_stage < 4:
#					current_stage += 1
#					alarm_0 = 2.0
#					for missile in get_tree().get_root().get_children():
#						if missile.is_in_group("enemy"):
#							if missile.boss_stage == current_stage:
#								missile.activated = true
								

			
#	if alarm_0 < 0:
#		alarm_0 = ALARM_DELAY
#		if stage_terminated == true:
#			if ship_num - ship_destroyed < ship_sim_max:
#				if ship_type == "Bomber01":
#					ship_instance = preload(BOMBER01_PATH)
#				var ship = ship_instance.instance()
#				get_tree().get_root().add_child(ship)
#				ship.carrier = self
#				if ship_level != 0:
#					var new_ship_level = randi()%ship_level#ship_num%ship_level
#					ship.fire_mode = new_ship_level
#				else:
#					ship.fire_mode = 0
#				var i = randi()%EXPLOBOM_DROP_RATE-ship_level
#				if i == 0:
#					ship.fire_mode = 10 #EXPLOBOMBER!!!
#				
#				var ship_pos = ship.get_pos()
#				ship_num += 1
#				ship_pos.x = round(rand_range(get_viewport_rect().pos.x+X_MARGIN,get_viewport_rect().end.x-X_MARGIN))
#				ship_pos.y = get_viewport_rect().pos.y - SHIP_Y_POS_INI
#				
#				ship.set_pos(ship_pos)
#				
#		elif ship_destroyed >= ship_max:
#			#report to the overmind that the ship fleet is destroyed
#			overmind.level_spawner_destroyed += 1
#			#destroy the carrier
#			queue_free()
