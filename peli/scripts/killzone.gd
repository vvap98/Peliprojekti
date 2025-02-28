extends Area2D

@onready var timer: Timer = $Timer
#var hp = 3
var player_in_area = false

var player
func _ready():
	player = get_tree().get_first_node_in_group("player")
	
func _process(delta: float) -> void:
	if player in get_overlapping_bodies():
		player_in_area = true
	else:
		player_in_area = false
		
	print(player_in_area)
	
	if player_in_area:
		player.getDamaged()
	#while overlaps_body(player):
	#	player.getDamaged()
	#for i in get_overlapping_bodies():
	#	if i == player:
	#		i.getDamaged()

#func _on_body_entered(body: Node2D) -> void:
#	if body == player:body.getDamaged()
