extends Node2D

func _process(delta):
	if Input.is_action_just_pressed("restart_button"):
		queue_free()
		get_tree().reload_current_scene()
