extends Spatial

func _init():

	set_hidden(true)

func explode():

	for child in get_children():
		
		if child.get_type() == "MeshInstance":
			child.explode()
			
func blink(nb):
	
	for child in get_children():
		if child.get_type() == "MeshInstance":
			child.blink(nb)