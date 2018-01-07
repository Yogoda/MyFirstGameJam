extends Node2D

const MAX_LEVEL = 1 #number of game levels
var current_level = 1
var level_status = "starting"
const CARRIER_INSTANCE = preload("res://instance/Carrier.tscn")
const PLAYER_INSTANCE = preload("res://instance/Player.tscn")
const STARTING_DELAY = 2
const ONGOING_DELAY = 5
const ENDING_DELAY = 5
const RESPAWN_DELAY = 1
var game_over = false
var player_ship = 3
var player_destroyed = true
var player_respawn_delay = -1
var alarm_0 = STARTING_DELAY
var level_spawner_max = 0
var level_spawner_num = 0
var level_spawner_destroyed = 0
var level_spawner_sim_max = 0 #number of spawner that are allowed simultaneously

func _ready():
	set_process(true)

func _process(delta):
	#UPDATE ALARMS
	alarm_0 -= delta
	if alarm_0 < 0:
		alarm_0 = -1
		
	if player_destroyed == true:
		player_respawn_delay -= delta
		if player_respawn_delay < 0:
			if player_ship > 0:
				player_ship -= 1
				player_respawn_delay = RESPAWN_DELAY
				player_destroyed = false
				var player_ship = PLAYER_INSTANCE.instance()
				get_tree().get_root().add_child(player_ship)
			else:
				game_over = true
			
	if alarm_0 < 0:
		if level_status == "starting":
			get_tree().get_root().get_node("World").get_node("Level").level = current_level
			level_spawner_num = 0
			level_spawner_destroyed = 0
			if current_level == 1:
				level_spawner_max = 4
				level_spawner_sim_max = 2
				level_status = "ongoing"
			
		elif level_status == "ending":
			if current_level < MAX_LEVEL:
				current_level += 1
				level_status = "starting"
				alarm_0 = STARTING_DELAY
			
		elif level_status == "ongoing":
			alarm_0 = ONGOING_DELAY
			if level_spawner_num < level_spawner_max:
				if level_spawner_num - level_spawner_destroyed < level_spawner_sim_max: #spawn a new carrier !!!
					level_spawner_num += 1
					var carrier = CARRIER_INSTANCE.instance()
					get_tree().get_root().add_child(carrier)
					carrier.overmind = self
					if current_level == 1:
						carrier.ship_type = "Bomber01"

			elif level_spawner_destroyed == level_spawner_max:
				level_status = "ending"
				alarm_0 = ENDING_DELAY