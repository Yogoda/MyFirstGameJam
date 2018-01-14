extends StreamPlayer

var ini = true

func _ready():

	set_process(true)

func _process(delta):
	if ini == true:
		set_volume(Globals.get("music_level"))
		ini = false
