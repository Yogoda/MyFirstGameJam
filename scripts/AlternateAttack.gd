extends ProgressBar

var text = "!! BRICKS BLASTER READY !!"

func _ready():
	var position = get_pos()
	var size = get_size()
	size.width = get_viewport_rect().end.x
	set_size(size)
	position.x = get_viewport_rect().pos.x
	position.y = get_viewport_rect().end.y - size.y
	set_pos(position)
	
	var label = get_children()
	for child in get_children():
		if child.get_type() == "Label":
			child.set_pos(position)
			child.set_size(size)
	#initialization
	set_process(true)

func _process(delta):
	if get_value() == get_max():
		for child in get_children():
			if child.get_type() == "Label":
				child.set_text(text)
	else:
		for child in get_children():
			if child.get_type() == "Label":
				child.set_text("TEST TEXT")