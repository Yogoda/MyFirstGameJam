extends Node2D

const MAX_LEVEL = 5 #number of game levels
var current_level = 1
var level_status = "starting"
const CARRIER_INSTANCE = preload("res://instance/Carrier.tscn")
const PLAYER_INSTANCE = preload("res://instance/Player.tscn")
const GAME_OVER_INSTANCE = preload("res://instance/Game_over.tscn")
const STAGE_CLEARED_INSTANCE = preload("res://instance/Stage_Cleared.tscn")
const VICTORY_INSTANCE = preload("res://instance/Victory.tscn")
const STARTING_DELAY = 2
const ONGOING_DELAY = 2
const ENDING_DELAY = 2
const RESPAWN_DELAY = 1
var game_over = false
var victory = false
var player_ship = 3
var ship_level = 1
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
				print(player_ship)
				player_respawn_delay = RESPAWN_DELAY
				player_destroyed = false
				var player_ship = PLAYER_INSTANCE.instance()
				get_tree().get_root().add_child(player_ship)
			else:
				if victory == false:
					game_over = true
					var game_over_inst = GAME_OVER_INSTANCE.instance()
					get_tree().get_root().add_child(game_over_inst)
				
			
	if alarm_0 < 0:
		print(level_status)
		if level_status == "starting":
			get_tree().get_root().get_node("World").get_node("Level").level = current_level
			level_spawner_num = 0
			level_spawner_destroyed = 0
			level_status = "ongoing"
			if current_level == 1:
				level_spawner_max = 4
				level_spawner_sim_max = 2
				ship_level = 1
			if current_level == 2:
				level_spawner_max = 4
				level_spawner_sim_max = 2
				ship_level = 2
			if current_level == 3:
				level_spawner_max = 4
				level_spawner_sim_max = 2
				ship_level = 3
			if current_level == 4:
				level_spawner_max = 4
				level_spawner_sim_max = 2
				ship_level = 4
			if current_level == 5:
				level_spawner_max = 4
				level_spawner_sim_max = 2
				ship_level = 5
			if current_level == 6:
				level_spawner_max = 6
				level_spawner_sim_max = 3
				ship_level = 3
			if current_level == 7:
				level_spawner_max = 4
				level_spawner_sim_max = 2
				ship_level = 4
			if current_level == 8:
				level_spawner_max = 6
				level_spawner_sim_max = 3
				ship_level = 4
				
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
					carrier.ship_type = "Bomber01"
					carrier.ship_level = ship_level

			elif level_spawner_destroyed == level_spawner_max:
				level_status = "ending"
				alarm_0 = ENDING_DELAY
				if player_destroyed == false and game_over == false:
					var player_ship = get_tree().get_root().get_node("Player")
					player_ship.end_level = true
					if current_level < MAX_LEVEL:
						var stage_cleared = STAGE_CLEARED_INSTANCE.instance()
						get_tree().get_root().add_child(stage_cleared)
					else:
						#VICTORY!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
						var game_victory = VICTORY_INSTANCE.instance()
						get_tree().get_root().add_child(game_victory)
						victory = true