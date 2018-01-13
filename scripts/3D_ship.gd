extends Spatial

func _init():

	set_hidden(true)

func explode():

	for child in get_children():
		child.explode()

func blink(nb):
	
	for child in get_children():
		child.blink(nb)