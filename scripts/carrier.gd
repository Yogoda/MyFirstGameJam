extends Node2D

const SHIP_Y_POS_INI = 100 #initial y position of the ship out of screen
var spawn_delay = 4
var alarm_0 = 0
var overmind
const BOMBER01_PATH = "res://instance/Bomber01.tscn"
const EXPLOBOM_DROP_RATE = 20
const COPTER_DROP_RATE = 25
const X_MARGIN = 50
var ship_type = "Bomber01"
var ship_level = 0
var ship_max = 8
var ship_num = 0
var ship_destroyed = 0
var ship_sim_max = 4 #number of spawner that are allowed simultaneously
var ship_instance

func _ready():
	set_process(true)

func _process(delta):
	alarm_0 -= delta
	if alarm_0 < 0:
		alarm_0 = -1
		
	if alarm_0 < 0:
		alarm_0 = spawn_delay
		if ship_num < ship_max:
			if ship_num - ship_destroyed < ship_sim_max:
				if ship_type == "Bomber01":
					ship_instance = preload(BOMBER01_PATH)
				var ship = ship_instance.instance()
				get_tree().get_root().add_child(ship)
				ship.carrier = self
				if ship_level != 0:
					var new_ship_level = randi()%ship_level#ship_num%ship_level
					ship.fire_mode = new_ship_level
				else:
					ship.fire_mode = 0
				var i = randi()%EXPLOBOM_DROP_RATE-ship_level
				if i == 0:
					ship.fire_mode = 10 #EXPLOBOMBER!!!
				i = randi()%COPTER_DROP_RATE
				if i == 0:
					ship.fire_mode = 3 #CHOPTER!!!
				
				var ship_pos = ship.get_pos()
				ship_num += 1
				ship_pos.x = round(rand_range(get_viewport_rect().pos.x+X_MARGIN,get_viewport_rect().end.x-X_MARGIN))
				ship_pos.y = get_viewport_rect().pos.y - SHIP_Y_POS_INI
				
				ship.set_pos(ship_pos)
				
		elif ship_destroyed >= ship_max:
			#report to the overmind that the ship fleet is destroyed
			overmind.level_spawner_destroyed += 1
			#destroy the carrier
			queue_free()
			
