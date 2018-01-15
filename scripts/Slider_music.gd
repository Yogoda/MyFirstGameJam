extends HSlider
var previous_val = 50

func _ready():
	set_process_input(true)
	set_process(true)
	
func _input(event):
		if previous_val != get_val():
			Globals.set("music_level", get_val()/50)
			get_tree().get_root().get_node("Node").get_node("StreamPlayer").set_volume(Globals.get("music_level"))
			previous_val = get_val()
	