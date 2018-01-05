extends Spatial

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	set_process(true)
	
func _process(delta):
	rotate_x(0.1)
	rotate_y(0.1)
	rotate_z(0.1)
