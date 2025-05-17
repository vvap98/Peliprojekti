extends Area2D

@onready var timer: Timer = $Timer
@onready var label: Label = $Label
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var sprite_2d: Sprite2D = $Sprite2D

var player
func _ready():
	player = get_tree().get_first_node_in_group("player")

func _on_body_entered(body: Node2D) -> void:
	if body == player:
		print("Got Dash!")
		label.visible = true
		timer.start()
		player.can_dash = true
		player.dash_icon.visible = true
		#queue_free()
		sprite_2d.visible = false
		collision_shape_2d.disabled = true


func _on_timer_timeout() -> void:
	#self.set_deferred("monitoring", true)
	#self.visible = true
	label.visible = false
