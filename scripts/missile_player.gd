extends Area2D

var speed = 500
const SCREEN_MARGIN = 20
var velocity = Vector2(0,-speed)
var mad_dog_mode = false
var amplitude = 0
var amp_up = false
const MAX_AMPLITUDE  = 2

var destroy = false

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
		missile_pos.x += velocity.x*sin(amplitude) * delta
		missile_pos.y += velocity.y * cos(amplitude)*delta
		
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
			get_tree().get_root().get_node("World").get_node("Score").score += other.HIT_SCORE
			queue_free()
