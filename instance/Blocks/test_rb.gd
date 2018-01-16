extends RigidBody

func _ready():
	apply_impulse(get_global_transform().origin, Vector3(0, 0, 1))
