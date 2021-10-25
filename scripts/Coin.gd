extends Area2D

export(String) var level_name
export(bool) var final_level

onready var coinAudioPlayer = get_node("/root/LevelClearAudioPlayer")

func _on_Coin_body_entered(body):
	coinAudioPlayer.play()
	queue_free()
	if final_level:
		get_tree().change_scene("res://UI/TitleScreen.tscn")
	else:
		get_tree().change_scene("res://Levels/" + level_name + ".tscn")
