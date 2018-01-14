extends StreamPlayer


func _ready():
	set_volume(get_tree().get_root().get_node("Node").pub_music_level)
	pass
