extends Node

var so_level = 0.5
var life_time = 1

func play_sound():
	
	var i = randi()%3
	
	var so_player = get_node("SoPlayerHit")
	var so_id
	if i == 0:
		so_id = so_player.play("Hit_Hurt")
	elif i == 1:
		so_id = so_player.play("Hit_Hurt2")
	else:
		so_id = so_player.play("Hit_Hurt3")
		
	so_player.set_volume(so_id, so_level)

func _ready():

	set_process(true)

	so_level = get_tree().get_root().get_node("World").pub_sound_level
	play_sound()

func _process(delta):
	
	life_time -= delta
	if life_time <= 0:
		queue_free()