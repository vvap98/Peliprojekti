extends CharacterBody2D

var spawnPos : Vector2
var air = true

@onready var timer: Timer = $Timer

func _ready() -> void:
	global_position = spawnPos

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	elif air == true:
		air = false
		timer.start()
	
	move_and_slide()


func _on_timer_timeout() -> void:
	queue_free()
