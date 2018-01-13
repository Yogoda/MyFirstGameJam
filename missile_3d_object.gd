extends Spatial

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var rotationSpeed = 0.03
var scale = 1

var rotation

func _ready():
	
	rotation = Vector3(rand_range(-1, 1), rand_range(-1, 1), rand_range(-1, 1))
	
	set_hidden(true)
	set_scale(Vector3(scale,scale,scale))
	set_fixed_process(true)
	
func _fixed_process(delta):
	
	rotate(rotation, rotationSpeed)