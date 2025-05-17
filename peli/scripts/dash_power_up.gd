extends Area2D

@onready var timer: Timer = $Timer
@onready var label: Label = $Label

var player
func _ready():
	player = get_tree().get_first_node_in_group("player")

func _on_body_entered(body: Node2D) -> void:
	if body == player:
		print("Got Dash!")
		label.visible = true
		#timer.start()
		player.can_dash = true
		player.dash_icon.visible = true
		queue_free()
		#self.visible = false
		#self.set_deferred("monitoring", false)


func _on_timer_timeout() -> void:
	#self.set_deferred("monitoring", true)
	#self.visible = true
	label.visible = false
