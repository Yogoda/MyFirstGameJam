extends Area2D

const SPEED = 150
const SCREEN_MARGIN = 20
var so_level = 0.5
var destroy = false
var velocity = Vector2(0,SPEED)

func _ready():
	connect("area_enter",self,"_on_area_enter")
	set_process(true)
	so_level = get_tree().get_root().get_node("World").pub_sound_level
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
		if other.invicible == false:
			if other.structure_points > 3:#lose all power ups
				other.structure_points = 3
			else:
				other.structure_points -= 1
			var so_player = get_tree().get_root().get_node("World").get_node("SoPlayerHit")
			var so_id = so_player.play("Hit_Hurt4")
			so_player.set_volume(so_id,so_level)
			queue_free()
		