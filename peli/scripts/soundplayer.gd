extends Node

@onready var audioStreamPlayer = $AudioPlayers/AudioStreamPlayer2D

func play_sound():
	audioStreamPlayer.play()
