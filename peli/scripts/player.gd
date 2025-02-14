extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -600.0
var hp = 3
var can_attack = true
#func handleHp() -> void:
	
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var cooldowntimer: Timer = $Sprite2D/Hitbox/Timer
@onready var hitbox: ShapeCast2D = $Sprite2D/Hitbox

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	if Input.is_action_just_released("jump") && velocity.y < 0:
		velocity.y = 0

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("moveLeft", "moveRight")
	
		
	if direction > 0:
		sprite_2d.flip_h = false
		hitbox.target_position = Vector2(86.0, 0.0)
	elif direction < 0: 
		sprite_2d.flip_h = true
		hitbox.target_position = Vector2(-86.0, 0.0)
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if Input.is_action_just_pressed("attack") and can_attack:
		print("attack")
		can_attack = false
		cooldowntimer.start()
		if hitbox.is_colliding():
			for i in hitbox.get_collision_count():
				var body = hitbox.get_collider(i)
				if body.is_in_group("enemy"):
					print("enemy damaged")
				
	move_and_slide()

func _on_timer_timeout() -> void:
	can_attack = true
