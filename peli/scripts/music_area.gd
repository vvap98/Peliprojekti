extends Area2D

@export var select_music_0_1_or_2 : int = 0
var player

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")



func _on_body_entered(body: Node2D) -> void:
	if body == player:
		("print")
		if select_music_0_1_or_2 == 0: player.rauhallinen_player.play()
		elif select_music_0_1_or_2 == 1: player.perus_player.play()
		elif select_music_0_1_or_2 == 2: player.uhmakas_player.play()

func _on_body_exited(body: Node2D) -> void:
	if select_music_0_1_or_2 == 0: player.rauhallinen_player.stop()
	elif select_music_0_1_or_2 == 1: player.perus_player.stop()
	elif select_music_0_1_or_2 == 2: player.uhmakas_player.stop()
