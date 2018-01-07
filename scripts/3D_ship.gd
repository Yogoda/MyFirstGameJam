extends Spatial

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var explForce = 0.1
var rotSpeed = 4;

func _init():

	set_hidden(true)

func explode():

	for child in get_children():
		
		if child.get_type() == "RigidBody":

			child.explode()
#			print(child.get_translation() * Vector3(explForce, 0, explForce))
			
#			child.translate(child.get_translation() * Vector3(explForce, 0, explForce))
#			child.rotate(Vector3(rand_range(0,rotSpeed), rand_range(0,rotSpeed), rand_range(0,rotSpeed)), 0.01)
#			child.rotate(Vector3(0,0,0), 0.01)
			
#			child.apply_impulse(get_global_transform().origin, (child.get_global_transform().origin - get_global_transform().origin) * 10)
#			child.set_angular_velocity(Vector3(rand_range(0,rotSpeed), rand_range(0,rotSpeed), rand_range(0,rotSpeed)))
