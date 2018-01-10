extends Button

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	
	connect("pressed", self, "start_game")
	set_process_input(true)
	
func _input(event):
	
	if event.is_action("ui_accept"):
		start_game()
	
func start_game():
	
		for node in get_tree().get_root().get_children():
			node.queue_free()
			
		get_tree().change_scene("res://Scenes/World.tscn")