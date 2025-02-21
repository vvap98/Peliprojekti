extends Area2D

@onready var timer: Timer = $Timer

var player
func _ready():
	player = get_tree().get_first_node_in_group("player")
	

func _on_body_entered(body: Node2D) -> void:
	if body == player:
		print("Got Double Jump!")
		#queue_free()
		timer.start()
		player.can_double_jump = true
		
		self.visible = false
		self.set_deferred("monitoring", false)


func _on_timer_timeout() -> void:
	self.set_deferred("monitoring", true)
	self.visible = true
