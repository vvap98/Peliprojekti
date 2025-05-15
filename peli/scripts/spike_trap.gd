extends Area2D

var world

@onready var spikeball = preload("res://scenes/spikeball.tscn")
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var timer: Timer = $Timer

@export var on_wall : bool
@export var flipped : bool 
var player
var can_spawn = true

func _ready() -> void:
	world = get_tree().get_root().get_node("World")
	player = get_tree().get_first_node_in_group("player")
	if on_wall:
		self.rotation_degrees = 90
	if flipped:
		self.rotation_degrees += 180

func _process(_delta: float) -> void:
	if overlaps_body(player):
		player.getDamaged()
#func _on_body_entered(body: Node2D) -> void:
	#if body.is_in_group("player"):
	#spawn_spike()

func spawn_spike():
	#if can_spawn:
	var instance = spikeball.instantiate()
	instance.spawnPos = sprite_2d.global_position
	world.add_child.call_deferred(instance)
		#can_spawn = false
	#timer.start()

func _on_timer_timeout() -> void:
	can_spawn = true
