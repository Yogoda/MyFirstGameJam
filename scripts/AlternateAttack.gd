extends ProgressBar

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	var position = get_pos()
	var size = get_size()
	size.width = get_viewport_rect().end.x
	set_size(size)
	position.x = get_viewport_rect().pos.x
	position.y = get_viewport_rect().end.y - size.y
	set_pos(position)
	pass
