extends Area2D

func _on_Spike_body_entered(body):
	if body.name == "Player" or body.name == "seed":
		queue_free()
		get_tree().reload_current_scene()
