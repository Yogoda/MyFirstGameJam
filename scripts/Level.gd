extends Label


var level = 1

func _ready():
	set_process(true)

func _process(delta):
	set_text(str("LEVEL: ",level))