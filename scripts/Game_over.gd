extends Node2D

var timer = 2.5
const X_SHIFT = 25
var currentScene = null
var so_level = 0.5
var init = true

func _ready():
	
	var position = get_pos()
	position.y = round(get_viewport_rect().end.y/3)
	position.x = round(get_viewport_rect().end.x /2) - X_SHIFT
	#sound
	so_level = get_tree().get_root().get_node("World").pub_sound_level
	
	set_pos(position)
	set_process(true)
	
func _process(delta):
	timer -= delta
	
	if init == true:
		var so_player = get_tree().get_root().get_node("World").get_node("SoPlayerEvents")
		var so_id = so_player.play("GameOver")
		so_player.set_volume(so_id,so_level)
		init = false
		
	if timer < 0:
		#restart game !!!!
		for node in get_tree().get_root().get_children():
			node.queue_free()
			
		get_tree().change_scene("res://Scenes/World.tscn")
		
	pass
