extends Area2D

@export var label : Label
@export var timer_amount : float = 15.0
@onready var timer: Timer = $Timer
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
var player

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	timer.wait_time = timer_amount
	
func _on_body_entered(body: Node2D) -> void:
	if body == player and label:
		label.visible = true
		timer.start()
		sprite_2d.visible = false
		collision_shape_2d.set_deferred("disabled", true)

func _on_timer_timeout() -> void:
	if label:
		label.visible = false
		sprite_2d.visible = true
		collision_shape_2d.set_deferred("disabled", false)
