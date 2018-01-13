extends Node2D

var ship
onready var camera = get_node("/root/World/Camera")

var speed = 4
var camDist = 80;

export var setRotation = true
export var set_visiblity = true

func set_ship_position():

	for child in get_children():
		
		var ray_origin = camera.project_ray_origin(get_parent().get_pos())
		var ray_direction = camera.project_ray_normal(get_parent().get_pos())
		
		child.set_translation(ray_origin + ray_direction * camDist)
		
		if set_visiblity:
			child.set_hidden(false)
		
		if setRotation:
			child.set_rotation(Vector3(0,get_parent().get_rot(),0))

func blink(nr):
	for child in get_children():
		child.blink(nr)

func _ready():

	set_process(true)

func _process(delta):

	set_ship_position()