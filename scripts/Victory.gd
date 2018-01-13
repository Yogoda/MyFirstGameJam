extends Node2D

var timer = 1.5
const X_SHIFT = 25
var so_level = 0.5
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
	#sound
	so_level = get_tree().get_root().get_node("World").pub_sound_level

	set_process(true)
	
func _process(delta):
	timer -= delta
	if init == true:
		init = false
		var so_player = get_tree().get_root().get_node("World").get_node("SoPlayerEvents")
		var so_id = so_player.play("Victory")
		so_player.set_volume(so_id,so_level)
	
	if timer < 0:
		queue_free()
	pass
