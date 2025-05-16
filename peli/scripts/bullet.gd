extends Area2D

@export var SPEED = 5.0

var dir : float
var spawnPos : Vector2
var spawnRot : float
var zdex : int
var hit = false
var player
@onready var sprite_2d: Sprite2D = $Sprite2D

func _ready():
	global_position = spawnPos
	global_rotation = spawnRot
	player = get_tree().get_first_node_in_group("player")
	zdex = z_index

func _physics_process(delta: float) -> void:
	#print(get_overlapping_bodies())
	if has_overlapping_bodies():
		queue_free()
	if !hit:
		position += Vector2(0, -SPEED).rotated(dir)
	else: position -= Vector2(0, -SPEED).rotated(dir)
	#if is_on_wall() or is_on_ceiling() or is_on_floor():
	#	queue_free()
	#move_and_slide()

func damage():
	hit = true
	sprite_2d.flip_v = true
	print("hit bullet!")
	#velocity = -velocity

func _on_area_entered(area: Area2D) -> void:
	if (hit and area.is_in_group("hurtbox")):
		print("enemy damaged")
		area.damage()
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	if (hit and body.is_in_group("enemy")) or body == player:
		print("Hit!")
		body.getDamaged()
		queue_free()

func _on_timer_timeout() -> void:
	queue_free()
