extends Area2D


func _on_WarpToHallway_body_entered(body):
	get_tree().change_scene("res://World/Hallway.tscn");
