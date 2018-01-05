extends Node2D

const SPEED = 200
var up_direction = false
var down_direction = false
var left_direction = false
var right_direction = false

var player_control = true


func _ready():
	#initialization
	set_process(true)
	set_process_input(true)
	
func _input(event):
	#controls
	if player_control == true:
		if event.is_action("ui_left"):
			left_direction = true
		if event.is_action_released("ui_left"):
			left_direction = false
			
		if event.is_action("ui_right"):
			right_direction = true
		if event.is_action_released("ui_right"):
			right_direction = false
			
		if event.is_action("ui_up"):
			up_direction = true
		if event.is_action_released("ui_up"):
			up_direction = false
			
		if event.is_action("ui_down"):
			down_direction = true
		if event.is_action_released("ui_down"):
			down_direction = false
		
func _process(delta):
	#step events
	var player_pos = self.get_pos()
	if left_direction == true:
		player_pos.x -= SPEED * delta
	if right_direction == true:
		player_pos.x += SPEED * delta
	if up_direction == true:
		player_pos.y -= SPEED * delta
	if down_direction == true:
		player_pos.y += SPEED * delta
		
	self.set_pos(player_pos)
	