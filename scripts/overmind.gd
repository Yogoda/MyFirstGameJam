extends Node2D

const MAX_LEVEL = 1 #number of game levels
var current_level = 1
var level_status = "starting"
var end_game = false
const MOTHERSHIP_INSTANCE = preload("res://instance/Mothership.tscn")
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
var ini = true

func _ready():
	set_process(true)

func _process(delta):
	if ini == true:
		#let's play the music !!
		var main_stream = get_tree().get_root().get_node("World").get_node("StreamMain")
		if main_stream.is_playing() == false:
			main_stream.play()
		main_stream.set_volume(Globals.get("music_level"))
		ini = false
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
				if victory == false and end_game == false:
					game_over = true
					var game_over_inst = GAME_OVER_INSTANCE.instance()
					get_tree().get_root().add_child(game_over_inst)
					end_game = true
				
			
	if alarm_0 < 0:
		if level_status == "starting":
			get_tree().get_root().get_node("World").get_node("Level").level = current_level
			level_spawner_num = 0
			level_spawner_destroyed = 0
			level_status = "ongoing"
			if current_level == MAX_LEVEL:
				level_spawner_max = 1
				level_spawner_sim_max = 1
				ship_level = 1
			else:
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
					level_spawner_max = 6
					level_spawner_sim_max = 3
					ship_level = 4
				if current_level == 8:
					level_spawner_max = 6
					level_spawner_sim_max = 3
					ship_level = 5
				
		elif level_status == "ending":
			if current_level < MAX_LEVEL:
				current_level += 1
				level_status = "starting"
				alarm_0 = STARTING_DELAY

		elif level_status == "ongoing":
			alarm_0 = ONGOING_DELAY
			if level_spawner_num < level_spawner_max:
				if current_level == MAX_LEVEL: #BOSS
					level_spawner_num += 1
					var mothership = MOTHERSHIP_INSTANCE.instance()
					get_tree().get_root().add_child(mothership)
					mothership.overmind = self
					var mothership_pos = mothership.get_pos()
					mothership_pos.x = round(get_viewport_rect().end.x /2)
					mothership_pos.y = -100
					mothership.set_pos(mothership_pos)
					
					#let's play the music !!
					var main_stream = get_tree().get_root().get_node("World").get_node("StreamMain")
					var boss_stream = get_tree().get_root().get_node("World").get_node("StreamBoss")
					main_stream.stop()
					boss_stream.play()
					boss_stream.set_volume(Globals.get("music_level"))
					
					pass
				else:
					#let's play the music !!
					var main_stream = get_tree().get_root().get_node("World").get_node("StreamMain")
					var boss_stream = get_tree().get_root().get_node("World").get_node("StreamBoss")
					if main_stream.is_playing() == false:
						main_stream.play()
					boss_stream.stop()
					main_stream.set_volume(Globals.get("music_level"))
					
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
						if end_game == false:
							var game_victory = VICTORY_INSTANCE.instance()
							get_tree().get_root().add_child(game_victory)
							victory = true
							end_game = true
							#let's play the music !!
							var boss_stream = get_tree().get_root().get_node("World").get_node("StreamBoss")
							var end_stream = get_tree().get_root().get_node("World").get_node("StreamEnd")
							boss_stream.stop()
							end_stream.play()
							end_stream.set_volume(Globals.get("music_level"))