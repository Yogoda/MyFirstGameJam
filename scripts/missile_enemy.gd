extends Area2D

const SPEED = 150
const SCREEN_MARGIN = 20
var so_level = 0.5
var destroy = false
var velocity = Vector2(0,SPEED)
const EXPLOSION_INSTANCE = preload("res://instance/Explosion.tscn")

func _ready():
	connect("area_enter",self,"_on_area_enter")
	set_process(true)
	
func _process(delta):

	#step events

	var missile_pos = get_pos()
	
	missile_pos.x += velocity.x * delta
	missile_pos.y += velocity.y * delta
	
	#destroy if out of game range
	if missile_pos.x < get_viewport_rect().pos.x - SCREEN_MARGIN:
		destroy = true
	if missile_pos.x > get_viewport_rect().end.x + SCREEN_MARGIN:
		destroy = true
	if missile_pos.y < get_viewport_rect().pos.y - SCREEN_MARGIN:
		destroy = true
	if missile_pos.y > get_viewport_rect().end.y + SCREEN_MARGIN:
		destroy = true
	
	set_pos(missile_pos)
	
	if destroy == true:
		queue_free()

func _on_area_enter(other):

	if other.is_in_group("player"):
		
		if other.damage(1) > 0:

			#create explosion
			var explosion = EXPLOSION_INSTANCE.instance()
			get_tree().get_root().add_child(explosion)
			explosion.set_pos(get_pos())

		queue_free()
		