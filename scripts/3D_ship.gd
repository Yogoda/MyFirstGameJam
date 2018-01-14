extends Spatial

export var enabled = true
export var hide = true
export var rotate = false
export var rotation_speed = 15.0

func _init():

	set_hidden(true)
	
func _ready():
	
	set_process(true)
	
	if not hide:
		set_hidden(false)	

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