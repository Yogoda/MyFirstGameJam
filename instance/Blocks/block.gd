extends RigidBody

var dir
var explForce = 0.1
var rotSpeed = rand_range(-0.1, 0.1);
var rotAxis = Vector3(rand_range(0,1), rand_range(0,1), rand_range(0,1))
var dirMod = Vector3(rand_range(- explForce, explForce), 0, rand_range(- explForce, explForce))

func _ready():

	dir = get_translation() * 0.3 + dirMod

func explode():

	global_translate(dir)
	global_rotate(rotAxis, rotSpeed)
