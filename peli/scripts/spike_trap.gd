extends Area2D

var world

@onready var spikeball = load("res://scenes/spike_ball.tscn")
@onready var sprite_2d: Sprite2D = $Sprite2D

@export var on_wall : bool
@export var flipped : bool 

func _ready() -> void:
	world = get_tree().get_root().get_node("World")
	if on_wall:
		self.rotation_degrees = 90
	if flipped:
		self.rotation_degrees += 180

#func _on_body_entered(body: Node2D) -> void:
	#if body.is_in_group("player"):
	#spawn_spike()

func spawn_spike():
	var instance = spikeball.instantiate()
	instance.spawnPos = sprite_2d.global_position
	world.add_child.call_deferred(instance)
