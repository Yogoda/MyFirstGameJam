extends Control

var text = "!! BRICKS BLASTER READY !!"
var text2 = "Bricks Blaster warming..."
var ini = true

func _ready():
	#initialization
	set_process(true)

func _process(delta):
	var prog_bar = get_node("ProgressBar")
	var label = get_node("AltAttack_Label")
	
	if ini == true:
		var position
		var size
		position = get_pos()
		size = prog_bar.get_size()
		size.width = get_viewport_rect().size.width
		position.x = get_viewport_rect().pos.x
		position.y = get_viewport_rect().end.y - size.height
		set_pos(position)
#		prog_bar.set_pos(position)
		prog_bar.set_size(size)
		label.set_pos(Vector2(prog_bar.get_pos().x, prog_bar.get_pos().y - 4))
		label.set_size(size)
		ini = false
		
	if prog_bar.get_value() == prog_bar.get_max():
		label.set_text(text)
		label.color
	else:
		label.set_text(text2)
