extends Node

var exploding = false
var explodeTimer = 0.5

func _ready():
	set_process(true)

func _process(delta):
	
	if exploding:
		explodeTimer -= delta
		
		if explodeTimer <= 0:
			queue_free()
			
func explode(model):
	
	var ship = model.instance()
	add_child(ship)
	
	var camera = get_node("/root/World/Camera")
	var ray_origin = camera.project_ray_origin(get_parent().get_pos())
	var ray_direction = camera.project_ray_normal(get_parent().get_pos())
	ship.set_translation(ray_origin + ray_direction * 80)
	
	ship.set_hidden(false)
	
	ship.explode()
	exploding = true