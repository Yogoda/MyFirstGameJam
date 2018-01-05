extends Node2D

const SPEED = 400
var up_direction = false
var down_direction = false
var left_direction = false
var right_direction = false
var is_shooting = false
const SCREEN_MARGIN = 30
var position_initialize = true
var player_control = false
const PLAYER_Y_POS_START = 100 #x position afte which the player can take control
const PLAYER_Y_POS_INI = 200 #initial y position of the player out of screen
var structure_points = 1 
const STRUCTURE_POINTS_MAX = 4 #max level
var lives = 3

func _ready():
	#initialize player position
	var player_pos = get_pos()
	player_pos.y = get_viewport_rect().end.y + PLAYER_Y_POS_INI
	player_pos.x = round(get_viewport_rect().end.x /2)
	set_pos(player_pos)
	up_direction = true
	
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
			
		if event.is_action("ui_accept"):
			is_shooting = true
		if event.is_action_released("ui_accept"):
			is_shooting = false
				
func _process(delta):
	#step events
	var player_pos = get_pos()
	if left_direction == true:
		player_pos.x -= SPEED * delta
	if right_direction == true:
		player_pos.x += SPEED * delta
	if up_direction == true:
		player_pos.y -= SPEED * delta
	if down_direction == true:
		player_pos.y += SPEED * delta
	
	#Player must stay in scene
	if player_control == true:
		if player_pos.x + SCREEN_MARGIN > get_viewport_rect().end.x:
			player_pos.x = get_viewport_rect().end.x - SCREEN_MARGIN 
		if player_pos.y + SCREEN_MARGIN > get_viewport_rect().end.y:
			player_pos.y = get_viewport_rect().end.y - SCREEN_MARGIN
		if player_pos.x < get_viewport_rect().pos.x + SCREEN_MARGIN:
			player_pos.x = get_viewport_rect().pos.x + SCREEN_MARGIN
		if player_pos.y < get_viewport_rect().pos.y + SCREEN_MARGIN:
			player_pos.y = get_viewport_rect().pos.y + SCREEN_MARGIN
	else:
		if position_initialize == true:
			if player_pos.y < get_viewport_rect().end.y - PLAYER_Y_POS_START:
				up_direction = false
				player_control = true
				print (player_pos.y)
				
	set_pos(player_pos)
	
	
	