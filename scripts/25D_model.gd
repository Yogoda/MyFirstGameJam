extends Node2D

onready var ship = get_node("Model")
onready var camera = get_node("/root/World/Camera")

var speed = 4
var camDist = 15;

func _ready():
	set_process(true)

	#print(get_viewport_rect().size)
	#print(get_viewport_rect().end)

func _process(delta):

	#print(get_parent().get_pos())

	var ray_origin = camera.project_ray_origin(get_parent().get_pos())
	var ray_direction = camera.project_ray_normal(get_parent().get_pos())
	
	ship.set_translation(ray_origin + ray_direction * camDist)