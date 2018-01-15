extends Area2D

var speed = 60
const SCREEN_MARGIN = 20
var velocity = Vector2(0,speed)
var destroy = false

func _ready():
	connect("area_enter",self,"_on_area_enter")
	set_process(true)

func _process(delta):

	#step events

	var power_up_pos = get_pos()
	velocity = Vector2(0,speed)
	power_up_pos.x += velocity.x * delta
	power_up_pos.y += velocity.y * delta
	
	#destroy if out of game range
	if power_up_pos.x < get_viewport_rect().pos.x - SCREEN_MARGIN:
		destroy = true
	if power_up_pos.x > get_viewport_rect().end.x + SCREEN_MARGIN:
		destroy = true
	if power_up_pos.y < get_viewport_rect().pos.y - SCREEN_MARGIN:
		destroy = true
	if power_up_pos.y > get_viewport_rect().end.y + SCREEN_MARGIN:
		destroy = true
	
	set_pos(power_up_pos)
	
	if destroy == true:
		queue_free()

func _on_area_enter(other):

	if other.is_in_group("player"):
		
		if other.upgrade(1) > 0:
			var so_player = get_tree().get_root().get_node("World").get_node("SoPlayerPowerUp")
			var so_id = so_player.play("Powerup")
			so_player.set_volume(so_id,Globals.get("sound_level"))
			queue_free()
