extends Area2D

@onready var timer: Timer = $Timer
@onready var label: Label = $Label
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

var player
func _ready():
	player = get_tree().get_first_node_in_group("player")

func _on_body_entered(body: Node2D) -> void:
	if body == player:
		print("Got Double Jump!")
		label.visible = true
		timer.start()
		player.can_double_jump = true
		player.double_jump_icon.visible = true
		#queue_free()
		sprite_2d.visible = false
		collision_shape_2d.disabled = true


func _on_timer_timeout() -> void:
	label.visible = false
	#self.set_deferred("monitoring", true)
	#self.visible = true
