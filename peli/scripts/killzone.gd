extends Area2D

@onready var timer: Timer = $Timer
#var hp = 3
var player
func _ready():
	player = get_tree().get_first_node_in_group("player")
	
func _on_body_entered(body: Node2D) -> void:
	if body == player:body.getDamaged()
