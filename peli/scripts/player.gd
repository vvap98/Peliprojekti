extends CharacterBody2D

# TODO hahmolle hetkellinen kuolemattomuus sen jälkeen kun on ottanut damagea

const SPEED = 300.0
const JUMP_VELOCITY = -700.0
const ACCELERATION = 40

var hp = 5
var took_damage = false
var can_attack = true
var can_double_jump = false
var has_double_jumped = true
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
#var max_jumps = 1
#func handleHp() -> void:

@onready var animation_player: AnimationPlayer = $Sprite2D/AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var cooldowntimer: Timer = $Sprite2D/Hitbox/AttackTimer
@onready var hitbox: ShapeCast2D = $Sprite2D/Hitbox
@onready var health_bar: ProgressBar = $healthBar
@onready var sfx_player: AudioStreamPlayer2D = $Sfx/JumpPlayer
@onready var movement_player: AudioStreamPlayer2D = $Sfx/MovementPlayer
@onready var grapple: Node2D = $grappleController
@onready var damage_timer: Timer = $DamageTimer
@onready var dash: Node2D = $Dash
@onready var coyote_timer: Timer = $CoyoteTimer


func _ready() -> void:
	health_bar.init_health(hp)

func _physics_process(delta: float) -> void:
	#TODO kojoottiaika, eli pelaaja voi hypätä vielä platformilta putoamisen jälkeen
	
	# Painovoima
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and (is_on_floor() or grapple.launched or !coyote_timer.is_stopped()):
		velocity.y = JUMP_VELOCITY
		grapple.grappleRetract()
		sfx_player.play()
		coyote_timer.stop()
	elif Input.is_action_just_pressed("jump") and !has_double_jumped:
		sfx_player.play()
		velocity.y = JUMP_VELOCITY
		has_double_jumped = true
	# Stop jump if key is released
	if Input.is_action_just_released("jump") && velocity.y < 0:
		velocity.y = 0
	#print(velocity.y)
	# jos powerup on saatu, resettaa tuplahypyn pelaajan laskeutuessa
	if can_double_jump and is_on_floor():
		has_double_jumped = false
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("moveLeft", "moveRight")
	
	#if direction:
	#	velocity.x = direction * SPEED
	
	# Tarkistetaan pelaajan suunta ja lasketaan pelaajan nopeus kiihtyvyydellä
	if direction > 0 and not dash.dashing:
		if !movement_player.playing and is_on_floor() :
			movement_player.play()
		velocity.x = min(velocity.x + ACCELERATION, SPEED)
		sprite_2d.flip_h = false
		hitbox.target_position = Vector2(86.0, 0.0)
	elif direction < 0 and not dash.dashing:
		if !movement_player.playing and is_on_floor() :
			movement_player.play()
		velocity.x = max(velocity.x - ACCELERATION, -SPEED)
		sprite_2d.flip_h = true
		hitbox.target_position = Vector2(-86.0, 0.0)
	else:
		#if movement_player.playing:
		movement_player.stop()
		velocity.x = lerp(velocity.x, 0.0, 0.2)# move_toward(velocity.x, 0, SPEED)
	
	if Input.is_action_just_pressed("jump"):
		movement_player.stop()
	
	var was_on_floor = is_on_floor()
	
	move_and_slide()
	
	if was_on_floor and !is_on_floor():
		#print(is_on_floor())
		if !velocity.y < 0: 
			coyote_timer.start()
			print("coyote timer started")
	
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
					body.getDamaged()
				

func _on_attack_timer_timeout() -> void:
	can_attack = true

func _on_damage_timer_timeout() -> void:
	print("damage timer reset!")
	took_damage = false

func _process(_delta: float) -> void:
	#print(velocity.y)
	checkHP()
	if Input.is_action_just_pressed("reset"):
		playerDeath()
		

#Jos pelaajan hp on 0 kutsuu playerDeath()
func checkHP():
	if hp <= 0: 
		playerDeath()

func getDamaged():
	if !took_damage:
		damage_timer.start()
		took_damage = true
		hp = hp - 1
		health_bar._set_health(hp)
		print(hp)

#alustaa scenen pelaajan kuollessa
func playerDeath():
	get_tree().reload_current_scene()
