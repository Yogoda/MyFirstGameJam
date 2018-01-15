extends HSlider
var previous_val = 50
const DELAY = 0.3
var alarm_0 = DELAY

func _ready():
	if Globals.has("sound_level"):
		set_val(Globals.get("sound_level")*100)
		previous_val = get_val()
	set_process_input(true)
	set_process(true)

func _process(delta):
	alarm_0 -= delta
	if alarm_0 < 0:
		alarm_0 = -1
	
func _input(event):
		if previous_val != get_val():
			Globals.set("sound_level", get_val()/100)
			previous_val = get_val()
			#sound
			if alarm_0 < 0:
				var so_player = get_parent().get_node("SamplePlayer")
				var so_id = so_player.play("Blip_Select")
				so_player.set_volume(so_id,Globals.get("sound_level"))
				alarm_0 = DELAY