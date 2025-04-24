extends CharacterBody2D

var spawnPos : Vector2

func _ready() -> void:
	global_position = spawnPos

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	move_and_slide()
