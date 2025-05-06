extends Node2D

func _enter_tree():
	if Checkpoint.playerLastPosition:
		$Player.global_position = Checkpoint.playerLastPosition
