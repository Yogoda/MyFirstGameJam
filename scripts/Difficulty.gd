extends HSlider

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	set_process_input(true)
	
func _input(event):
	Globals.set("difficulty",get_val())
	