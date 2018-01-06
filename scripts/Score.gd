extends Label

var score = 0

func _ready():
	set_process(true)

func _process(delta):
	set_text(str("Score: ",score))
