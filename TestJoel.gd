extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

onready var ship = get_node("ShipMesh")
onready var camera = get_parent().get_node("Camera")

var speed = 4

func _ready():
	set_process(true)
	set_process_input(true)

	print(get_viewport_rect().size)
	print(get_viewport_rect().end)

func _process(delta):
	
	if Input.is_key_pressed(KEY_LEFT):
		set_pos(Vector2(get_pos().x-speed, get_pos().y))

	if Input.is_key_pressed(KEY_RIGHT):
		set_pos(Vector2(get_pos().x+speed, get_pos().y))
		
	if Input.is_key_pressed(KEY_UP):
		set_pos(Vector2(get_pos().x, get_pos().y - speed))

	if Input.is_key_pressed(KEY_DOWN):
		set_pos(Vector2(get_pos().x, get_pos().y + speed))

	var ray_origin = camera.project_ray_origin(get_pos() + get_viewport_rect().size/2)
	var ray_direction = camera.project_ray_normal(get_pos() + get_viewport_rect().size/2)
	
	#var pos = ship.get_translation()
	
	
	ship.set_translation(ray_origin + ray_direction)
	
	