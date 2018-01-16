extends Button

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	
	connect("pressed", self, "credits")
	set_process_input(true)
	
func _input(event):
	
	if event.is_action("ui_accept"):
		get_tree().get_root().get_node("Node").get_node("Credits").set_hidden(true)
	
func credits():
	
		get_tree().get_root().get_node("Node").get_node("Credits").set_hidden(false)