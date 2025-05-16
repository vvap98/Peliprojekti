extends Area2D

@onready var timer: Timer = $Timer

var player
func _ready():
	player = get_tree().get_first_node_in_group("player")

func _on_body_entered(body: Node2D) -> void:
	if body == player:
		print("Got Double Jump!")
		#timer.start()
		player.can_double_jump = true
		player.double_jump_icon.visible = true
		queue_free()
		#self.visible = false
		#self.set_deferred("monitoring", false)


func _on_timer_timeout() -> void:
	self.set_deferred("monitoring", true)
	self.visible = true
