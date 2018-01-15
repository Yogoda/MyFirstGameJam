extends Area2D
var mothership
var active_check = false
var hp = 75
var death = false
var death_duration = 0.5
var explode_delay = 1.5


func _ready():
	set_process(true)

func _process(delta):
	
	var position = get_pos()
	var m_position = mothership.get_pos()
	set_pos(m_position)
	
	if active_check == false:
		if mothership.current_stage > 2:
			explode_delay -= delta
			if explode_delay < 0:
				hp = 0
				active_check = false
			
	print (mothership.current_stage)

	if hp < 1 and death == false:
		get_node("25D Model/Model").explode()
		mothership.ship_destroyed += 1
		#sound of explosion
		var so_player = get_node("SamplePlayer")
		var so_id = so_player.play("Explosion6")
		so_player.set_volume(so_id,Globals.get("sound_level"))
		death = true
		
	if death == true:
		death_duration -= delta
		#get_node("25D Model/Model").explode()
		if death_duration < 0:
			queue_free()
