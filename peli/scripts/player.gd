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
var direction = 0
var last_direction = 1
#var max_jumps = 1
#func handleHp() -> void:

@onready var animation_player: AnimationPlayer = $Sprite2D/AnimationPlayer
#@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animatedSprite_2d: AnimatedSprite2D = %Sprite2D
@onready var cooldowntimer: Timer = $Sprite2D/HitBox/AttackTimer
@onready var hitbox: Area2D = $Sprite2D/HitBox
@onready var health_bar: ProgressBar = $healthBar

@onready var hit_player: AudioStreamPlayer2D = $HitPlayer
@onready var attack_player: AudioStreamPlayer2D = $AttackPlayer
@onready var sfx_player: AudioStreamPlayer2D = $JumpPlayer
@onready var movement_player: AudioStreamPlayer2D = $MovementPlayer
@onready var landing_player: AudioStreamPlayer2D = $LandingPlayer


@onready var grapple: Node2D = $grappleController
@onready var damage_timer: Timer = $DamageTimer
@onready var dash: Node2D = $Dash
@onready var coyote_timer: Timer = $CoyoteTimer
@onready var attack: AnimatedSprite2D = $Sprite2D/HitBox/attack
@onready var player: CharacterBody2D = $"."
@onready var trap_hitbox: Area2D = $TrapHitbox


func _ready() -> void:
	health_bar.init_health(hp)

func _physics_process(delta: float) -> void:
	#TODO kojoottiaika, eli pelaaja voi hypätä vielä platformilta putoamisen jälkeen
	
	# Painovoima
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and (is_on_floor() or !coyote_timer.is_stopped()):
		velocity.y = JUMP_VELOCITY
		#grapple.grappleRetract()
		sfx_player.play()
		coyote_timer.stop()
	elif Input.is_action_just_pressed("jump") and !has_double_jumped:
		sfx_player.play()
		velocity.y = JUMP_VELOCITY
		has_double_jumped = true
	if Input.is_action_just_pressed("jump") and grapple.launched:
		grapple.grappleRetract()
	# Stop jump if key is released
	if Input.is_action_just_released("jump") && velocity.y < 0:
		velocity.y = 0
	#print(velocity.y)
	# jos powerup on saatu, resettaa tuplahypyn pelaajan laskeutuessa
	if can_double_jump and is_on_floor():
		has_double_jumped = false
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction = Input.get_axis("moveLeft", "moveRight")
	if direction != 0:
		last_direction = direction #väliaikainen ratkaisu dashiin
	if direction == 0:
		animatedSprite_2d.play("Idle")
	else:
		animatedSprite_2d.play("Run")
	#	velocity.x = direction * SPEED
	
	# Tarkistetaan pelaajan suunta ja lasketaan pelaajan nopeus kiihtyvyydellä
	if direction > 0 and not dash.dashing:
		if !movement_player.playing and is_on_floor() :
			movement_player.play()
		velocity.x = min(velocity.x + ACCELERATION, SPEED)
		animatedSprite_2d.scale.x = abs(animatedSprite_2d.scale.x) #parempi tapa flipata sprite ja hitbox
	elif direction < 0 and not dash.dashing:
		if !movement_player.playing and is_on_floor() :
			movement_player.play()
		velocity.x = max(velocity.x - ACCELERATION, -SPEED)
		animatedSprite_2d.scale.x = -abs(animatedSprite_2d.scale.x)
	elif  not is_on_floor():
		velocity.x = lerp(velocity.x, 0.8 * velocity.x, 0.1)
	else:
		#if movement_player.playing:
		movement_player.stop()
		velocity.x = lerp(velocity.x, 0.0, 0.2)# move_toward(velocity.x, 0, SPEED)
	
	if Input.is_action_just_pressed("jump"):
		movement_player.stop()
	
	var was_on_floor = is_on_floor()
	
	move_and_slide()
	
	if !was_on_floor and is_on_floor():
		landing_player.play()
	
	if was_on_floor and !is_on_floor():
		#print(is_on_floor())
		if !velocity.y < 0: 
			coyote_timer.start()
			print("coyote timer started")
	
	# Check for attack input, then check if enemy is in attack 
	# hitbox area
	if Input.is_action_just_pressed("attack") and can_attack:
		print("attack")
		attack.play("attack")
		attack_player.play()
		can_attack = false
		cooldowntimer.start()
		var body_array = hitbox.get_overlapping_bodies()
		if hitbox.has_overlapping_bodies():
			for i in body_array:
				print(body_array)
				#var body = body_array[i]
				#if body.is_in_group("enemy"):
					#print("enemy damaged")
					#hit_player.play()
					#body.getDamaged()
				

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
		animation_player.play("flash")
		damage_timer.start()
		took_damage = true
		hp = hp - 1
		health_bar._set_health(hp)
		print(hp)

#alustaa scenen pelaajan kuollessa
func playerDeath():
	get_tree().reload_current_scene()


func _on_trap_hitbox_body_entered(body: Node2D) -> void:
	playerDeath()
