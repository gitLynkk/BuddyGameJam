extends Area2D

func _on_Coin_body_entered(body):
	queue_free()
	get_tree().change_scene("res://UI/UI_Nodes/LevelMenu.tscn")
