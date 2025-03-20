extends Area2D

@onready var timer: Timer = $Timer

var player
func _ready():
	player = get_tree().get_first_node_in_group("player")
	
func _process(_delta: float) -> void:
	if overlaps_body(player):
		#print("overlapping")
		player.getDamaged()

#func _on_body_entered(body: Node2D) -> void:
#	if body == player:body.getDamaged()
