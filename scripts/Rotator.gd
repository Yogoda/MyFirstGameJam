extends Spatial

export var rotation_speed = 15

var rotate = true

func _ready():
	set_process(true)
	
func _process(delta):
	if rotate:
		rotate(Vector3(0,1,0), rotation_speed * delta)
	
func explode():

	rotate = false
	for child in get_children():
		child.explode()
			
func blink(nb):
	
	for child in get_children():
		child.blink(nb)