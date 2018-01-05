extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	set_process(true)
	set_process_input(true)
	


func _process(delta):
	
	if Input.is_key_pressed(KEY_LEFT):
		set_pos(Vector2(get_pos().x-1, get_pos().y))
		
	if Input.is_key_pressed(KEY_RIGHT):
		set_pos(Vector2(get_pos().x+1, get_pos().y))
		