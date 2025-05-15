extends Area2D

var spawnPos : Vector2
var air = true

var fallspeed = 5
var player
@onready var timer: Timer = $Timer

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	global_position = spawnPos

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if air:
		position.y += fallspeed
	#	velocity += get_gravity() * delta
	if has_overlapping_bodies():
		if air == true:
			air = false
			timer.start()
			print("spike timer started")
	if overlaps_body(player):
		player.getDamaged()
	#move_and_slide()


func _on_timer_timeout() -> void:
	queue_free()


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("hurtbox"):
		area.damage()
