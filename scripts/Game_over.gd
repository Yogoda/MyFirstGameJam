extends Node2D

var timer = 1.5
const X_SHIFT = 25
var currentScene = null


func _ready():
	
	var position = get_pos()
	position.y = round(get_viewport_rect().end.y/3)
	position.x = round(get_viewport_rect().end.x /2) - X_SHIFT
	
	set_pos(position)
	set_process(true)
	
func _process(delta):
	timer -= delta
	
	if timer < 0:
		#restart game !!!!
		for node in get_tree().get_root().get_children():
			node.queue_free()
			
		get_tree().change_scene("res://Scenes/World.tscn")

	pass