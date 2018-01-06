extends Node2D

onready var ship = get_node("Model")
onready var camera = get_node("/root/World/Camera")

var speed = 4
var camDist = 100;

func set_ship_position():
	
	var ray_origin = camera.project_ray_origin(get_parent().get_pos())
	var ray_direction = camera.project_ray_normal(get_parent().get_pos())
	
	ship.set_translation(ray_origin + ray_direction * camDist)

func _ready():
	
	set_process(true)
	set_ship_position()

func _process(delta):

	set_ship_position()