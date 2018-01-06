extends Spatial

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var rotSpeed = 4;

func explode():

	for child in get_children():
		if child.get_type() == "RigidBody":
			child.apply_impulse(get_transform().origin, (child.get_global_transform().origin - get_global_transform().origin) * 10)
			child.set_angular_velocity(Vector3(rand_range(0,rotSpeed), rand_range(0,rotSpeed), rand_range(0,rotSpeed)))
