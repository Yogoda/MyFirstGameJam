extends Node2D

onready var ship = get_node("Model")
onready var camera = get_node("/root/World/Camera")

var speed = 4
var camDist = 4;

func _ready():
	set_process(true)

func _process(delta):

	var ray_origin = camera.project_ray_origin(get_parent().get_pos())
	var ray_direction = camera.project_ray_normal(get_parent().get_pos())
	
	ship.set_translation(ray_origin + ray_direction)
	
	