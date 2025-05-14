extends CharacterBody2D


@export var SPEED = 300.0

@onready var hurtbox: Area2D = $HitboxComponent

var dir : float
var spawnPos : Vector2
var spawnRot : float
var zdex : int
var hit = false
var player

func _ready():
	global_position = spawnPos
	global_rotation = spawnRot
	player = get_tree().get_first_node_in_group("player")
	zdex = z_index

func _physics_process(delta: float) -> void:
	#if !hit:
	velocity = Vector2(0, -SPEED).rotated(dir)
	if is_on_wall() or is_on_ceiling() or is_on_floor():
		queue_free()
	move_and_slide()

func getDamaged():
	hit = true
	velocity = -velocity

func _on_hitbox_body_entered(body: Node2D) -> void:
	if (hit and body.is_in_group("enemy")) or body == player:
		print("Hit!")
		body.getDamaged()
		queue_free()

func _on_timer_timeout() -> void:
	queue_free()


func _on_hitbox_area_entered(area: Area2D) -> void:
	if (hit and area.is_in_group("hurtbox")):
		print("enemy damaged")
		area.damage()
		queue_free()
