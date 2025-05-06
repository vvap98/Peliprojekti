extends Area2D


func _on_body_entered(body: Node2D) -> void:
	Checkpoint.playerLastPosition = global_position
	print("checkpoint")
