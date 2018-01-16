extends Button

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	
	connect("pressed", self, "options")
	set_process_input(true)
	
func options():
	
		get_tree().get_root().get_node("Node").get_node("Options").set_hidden(false)