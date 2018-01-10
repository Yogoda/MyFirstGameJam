extends Area2D

var so_level = 0.5
var speed = 500
const SCREEN_MARGIN = 8
var velocity = Vector2(0,-speed)
var mad_dog_mode = false
var amplitude = 0
var amp_up = false
const MAX_AMPLITUDE  = 0.6

var destroy = false

func _ready():
	so_level = get_tree().get_root().get_node("World").pub_sound_level
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
		queue_free()

func _on_area_enter(other):
	if other.is_in_group("enemy"):
		if other.death == false:
			other.hp -= 1
			other.get_node("25D Model/Model").blink(1)
			get_tree().get_root().get_node("World").get_node("Score").score += other.HIT_SCORE
			#play sound !
			var i = randi()%3
			
			var so_player = get_tree().get_root().get_node("World").get_node("SoPlayerHit")
			var so_id = so_player.play("Hit_Hurt")
			if i == 0:
				so_id = so_player.play("Hit_Hurt")
			elif i == 1:
				so_id = so_player.play("Hit_Hurt2")
			else:
				so_id = so_player.play("Hit_Hurt3")
			so_player.set_volume(so_id,so_level)
			
			#increase the alternate attack progress bar
			var prog_bar = get_tree().get_root().get_node("World").get_node("AlternateAttack")
			var prog_bar_value = prog_bar.get_value()
			prog_bar_value += prog_bar.get_step()
			prog_bar.set_value(prog_bar_value)
			queue_free()
