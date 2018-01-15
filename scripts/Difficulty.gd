extends HSlider

var previous_val = 1

func _ready():
	if Globals.has("difficulty"):
		set_val(Globals.get("difficulty"))
		previous_val = get_val()
		
	set_process_input(true)
	
func _input(event):
	if previous_val != get_val():
		#sound
		var so_player = get_parent().get_node("SamplePlayer")
		var so_id = so_player.play("Blip_Select")
		so_player.set_volume(so_id,Globals.get("sound_level"))
		Globals.set("difficulty",get_val())
		previous_val = get_val()
	