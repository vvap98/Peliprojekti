extends Area2D

@onready var timer: Timer = $Timer
#var hp = 3
var player
func _ready():
	player = get_tree().get_first_node_in_group("player")
	
func _on_body_entered(body: Node2D) -> void:
	if body == player:
		print(player.hp)
		player.hp = player.hp - 1
		if player.hp <= 0:
			timer.start()

func _on_timer_timeout() -> void:
	get_tree().reload_current_scene()
