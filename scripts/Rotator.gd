extends Spatial

export var rotation_speed = 0.01

func _ready():
	set_process(true)
	
func set_process(delta):
	rotate(Vector3(0,1,0), rotation_speed * delta)