extends Node2D

var timer = 5
const X_SHIFT = 25
var init = true

func _ready():
	var label = get_node("Label")
	var position = get_pos()
	var size = label.get_size()
	size.width = get_viewport_rect().end.x
	position.x = get_viewport_rect().pos.x
	position.y = round(get_viewport_rect().end.y/3)
	label.set_size(size)
	set_pos(position)

	set_process(true)
	
func _process(delta):
	timer -= delta
	if init == true:
		init = false
		var so_player = get_tree().get_root().get_node("World").get_node("SoPlayerEvents")
		var so_id = so_player.play("Victory")
		so_player.set_volume(so_id,Globals.get("sound_level"))
	
	if timer < 0:
		#restart game !!!!
		for node in get_tree().get_root().get_children():
			node.queue_free()
			
		get_tree().change_scene("res://Scenes/Menu.tscn")
#		get_tree().get_root().get_node("Node").show_credits()
