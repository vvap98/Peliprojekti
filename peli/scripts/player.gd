extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -700.0
const ACCELERATION = 10

var hp =5
var can_attack = true
var jumps = 1
#func handleHp() -> void:
	
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var cooldowntimer: Timer = $Sprite2D/Hitbox/Timer
@onready var hitbox: ShapeCast2D = $Sprite2D/Hitbox
@onready var health_bar: ProgressBar = $healthBar

func _ready() -> void:
	health_bar.init_health(hp) 

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and jumps > 0:
		velocity.y = JUMP_VELOCITY
		jumps -= 1
		print(jumps)
	# Stop jump if key is released
	if Input.is_action_just_released("jump") && velocity.y < 0:
		velocity.y = 0
	
	if is_on_floor():
		jumps = 1
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("moveLeft", "moveRight")
	
	#if direction:
	#	velocity.x = direction * SPEED
	
		
	if direction > 0:
		print(direction)
		print(velocity.x)
		velocity.x = min(velocity.x + ACCELERATION, SPEED)
		sprite_2d.flip_h = false
		hitbox.target_position = Vector2(86.0, 0.0)
	elif direction < 0:
		print(direction) 
		print(velocity.x)
		velocity.x = max(velocity.x - ACCELERATION, -SPEED)
		sprite_2d.flip_h = true
		hitbox.target_position = Vector2(-86.0, 0.0)
	else:
		print(direction)
		velocity.x = lerp(velocity.x, 0.0, 0.2)# move_toward(velocity.x, 0, SPEED)
	
	move_and_slide()
	
	# Check for attack input, then check if enemy is in attack 
	# hitbox area
	if Input.is_action_just_pressed("attack") and can_attack:
		print("attack")
		can_attack = false
		cooldowntimer.start()
		if hitbox.is_colliding():
			for i in hitbox.get_collision_count():
				var body = hitbox.get_collider(i)
				if body.is_in_group("enemy"):
					print("enemy damaged")
				

func _on_timer_timeout() -> void:
	can_attack = true

func _process(delta: float) -> void:
	checkHP()

#Checks when players hp reaches 0 and calls playerDeath()
func checkHP():
	if hp <= 0: 
		playerDeath()

func getDamaged():
	hp = hp - 1
	health_bar._set_health(hp)
	print(hp)

#resets the scene on death
func playerDeath():
	get_tree().reload_current_scene()
