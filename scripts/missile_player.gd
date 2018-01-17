extends Area2D

var speed = 500
const SCREEN_MARGIN = 8
var velocity = Vector2(0,-speed)
var mad_dog_mode = false
var amplitude = 0
var amp_up = false

const MAX_AMPLITUDE  = 0.6
const EXPLOSION_INSTANCE = preload("res://instance/Explosion.tscn")

const MISSILE_TYPE_1 = 1
const MISSILE_TYPE_2 = 2
const MISSILE_TYPE_3 = 3

var destroy = false
var destroy_timer = 0.5

func destroy():
	
	get_node("25D Model/Spatial").enabled = false
	get_node("25D Model/Spatial").set_hidden(true)
	destroy = true

func play_sound(missile_type):

	var so_player = get_node("SoPlayerShoot")
	var so_id 
	
	if missile_type == MISSILE_TYPE_1:
		so_id = so_player.play("Laser_Shoot1")
		so_player.set_volume(so_id,Globals.get("sound_level"))
	elif missile_type == MISSILE_TYPE_2:
		so_id = so_player.play("Laser_Shoot4")
		so_player.set_volume(so_id,0.5*Globals.get("sound_level"))
	elif missile_type == MISSILE_TYPE_2:
		so_id = so_player.play("Laser_Shoot5")
		so_player.set_volume(so_id,0.5*Globals.get("sound_level"))
		

func _ready():
	connect("area_enter",self,"_on_area_enter")
	set_process(true)
	
func _process(delta):
	if mad_dog_mode == true:
		if amp_up == false:
			amplitude -= delta
			if amplitude < -MAX_AMPLITUDE:
				amp_up = true
		else:
			amplitude += delta
			if amplitude > MAX_AMPLITUDE:
				amp_up = false
			
	#step events
	var missile_pos = get_pos()
	if mad_dog_mode == false:
		missile_pos.x += velocity.x * delta
		missile_pos.y += velocity.y *delta
	else:
		missile_pos.x += velocity.x*sin(amplitude)*delta
		missile_pos.y += velocity.y*cos(amplitude)*delta
		
	set_pos(missile_pos)
		
	#destroy if out of game range
	
	missile_pos = get_pos()
	
	if missile_pos.x < get_viewport_rect().pos.x - SCREEN_MARGIN:
		destroy = true
	if missile_pos.x > get_viewport_rect().end.x + SCREEN_MARGIN:
		destroy = true
	if missile_pos.y < get_viewport_rect().pos.y - SCREEN_MARGIN:
		destroy = true
	if missile_pos.y > get_viewport_rect().end.y + SCREEN_MARGIN:
		destroy = true
	
	if destroy == true:
		destroy_timer -= delta
		if destroy_timer <= 0:
			queue_free()

func _on_area_enter(other):
	if other.is_in_group("enemy"):
		if other.death == false and other.activated == true:
			other.hp -= 1
			other.get_node("25D Model").blink(1)
			if other.is_scoring == true:
				get_tree().get_root().get_node("World").get_node("Score").score += other.HIT_SCORE
			
			#create explosion
			var explosion = EXPLOSION_INSTANCE.instance()
			get_tree().get_root().add_child(explosion)
			explosion.set_pos(get_pos())
			
			#increase the alternate attack progress bar
			var prog_bar = get_tree().get_root().get_node("World").get_node("AlternateAttack").get_node("ProgressBar")
			var prog_bar_value = prog_bar.get_value()
			prog_bar_value += prog_bar.get_step()
			prog_bar.set_value(prog_bar_value)
			
			destroy()
