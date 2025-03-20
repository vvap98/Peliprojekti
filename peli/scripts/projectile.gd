extends CharacterBody2D


@export var SPEED = 300.0

var dir : float
var spawnPos : Vector2
var spawnRot : float
var zdex : int
var hit = false

func _ready():
	global_position = spawnPos
	global_rotation = spawnRot
	zdex = z_index

func _physics_process(delta: float) -> void:
	if !hit:
		velocity = Vector2(0, -SPEED).rotated(dir)
	
	move_and_slide()

func getDamaged():
	hit = true
	velocity = -velocity

func _on_hitbox_body_entered(body: Node2D) -> void:
	print("Hit!")
	queue_free()

func _on_timer_timeout() -> void:
	queue_free()
