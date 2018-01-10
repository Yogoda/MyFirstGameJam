extends Node2D

var ship
onready var camera = get_node("/root/World/Camera")

var speed = 4
var camDist = 100;

export var setRotation = true

func set_ship_position():

	ship.set_hidden(false)
	var ray_origin = camera.project_ray_origin(get_parent().get_pos())
	var ray_direction = camera.project_ray_normal(get_parent().get_pos())
	
	ship.set_translation(ray_origin + ray_direction * camDist)
	
	if setRotation:
		ship.set_rotation(Vector3(0,get_parent().get_rot(),0))

func _ready():

	set_process(true)

func _process(delta):
	ship = get_child(0)
	set_ship_position()