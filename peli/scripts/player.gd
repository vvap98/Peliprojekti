extends CharacterBody2D


var speed = 300.0
var prev_speed : float

const JUMP_VELOCITY = -700.0
const ACCELERATION = 50

var max_hp = 5
var hp
var took_damage = false
var can_attack = true
var can_double_jump = false
var has_double_jumped = true

var can_dash = false
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction = 0
var last_direction = 1

var last_position : Vector2
var was_on_ledge = false
var can_move = true


@onready var animation_player: AnimationPlayer = $Sprite2D/AnimationPlayer
@onready var flash_animation_player: AnimationPlayer = $Sprite2D/FlashAnimationPlayer
@onready var attack_animation_player: AnimationPlayer = $HitBox/AttackAnimationPlayer

@onready var animatedSprite_2d: AnimatedSprite2D = %Sprite2D
@onready var cooldowntimer: Timer = $HitBox/AttackTimer
@onready var hitbox: Area2D = $HitBox
@onready var health_bar: ProgressBar = $"CanvasLayer/healthBar"

@onready var hit_player: AudioStreamPlayer2D = $HitPlayer
@onready var attack_player: AudioStreamPlayer2D = $AttackPlayer
@onready var sfx_player: AudioStreamPlayer2D = $JumpPlayer
@onready var movement_player: AudioStreamPlayer2D = $MovementPlayer
@onready var landing_player: AudioStreamPlayer2D = $LandingPlayer
@onready var water_player: AudioStreamPlayer2D = $WaterPlayer
@onready var dash_player: AudioStreamPlayer2D = $DashPlayer


@onready var grapple: Node2D = $grappleController
@onready var damage_timer: Timer = $DamageTimer
@onready var dash: Node2D = $Dash
@onready var coyote_timer: Timer = $CoyoteTimer
@onready var fall_timer: Timer = $FallTimer
@onready var attack: AnimatedSprite2D = $HitBox/attack
@onready var player: CharacterBody2D = $"."
@onready var trap_hitbox: Area2D = $TrapHitbox
@onready var heal_box: Area2D = $HealBox
@onready var pit_ray: RayCast2D = $RayCast2D

var rng = RandomNumberGenerator.new()

func _ready() -> void:
	hp = max_hp
	health_bar.init_health(hp)
	last_position = global_position

func _physics_process(delta: float) -> void:
	#TODO kojoottiaika, eli pelaaja voi hypätä vielä platformilta putoamisen jälkeen
	
	# Painovoima
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if can_move:
		#pelaajan liikkuminen käsitellään erillisessä aliohjelmassa
		handle_inputs(delta)
	#print(velocity.y)
	# jos powerup on saatu, resettaa tuplahypyn pelaajan laskeutuessa
	if can_double_jump and is_on_floor():
		has_double_jumped = false
	
	
	# Tarkistetaan pelaajan suunta ja lasketaan pelaajan nopeus kiihtyvyydellä
	if direction > 0 and not dash.dashing:
		if !movement_player.playing and is_on_floor() :
			movement_player.play()
		if can_move: velocity.x = min(velocity.x + ACCELERATION, speed)
		animatedSprite_2d.scale.x = abs(animatedSprite_2d.scale.x) #parempi tapa flipata sprite ja hitbox
		if pit_ray.position.x < 0:
			pit_ray.position.x *= -1
	elif direction < 0 and not dash.dashing:
		if !movement_player.playing and is_on_floor() :
			movement_player.play()
		if can_move: velocity.x = max(velocity.x - ACCELERATION, -speed)
		animatedSprite_2d.scale.x = -abs(animatedSprite_2d.scale.x)
		if pit_ray.position.x > 0:
			pit_ray.position.x *= -1
	elif  not is_on_floor():
		velocity.x = lerp(velocity.x, 0.8 * velocity.x, 0.1)
	else:
		#if movement_player.playing:
		movement_player.stop()
		velocity.x = lerp(velocity.x, 0.0, 0.2)# move_toward(velocity.x, 0, SPEED)
	
	if !is_on_floor(): 
		movement_player.stop()
	if is_on_floor() and !pit_ray.is_colliding() and was_on_ledge == false:
		was_on_ledge = true
		last_position = global_position
		print(was_on_ledge)
		
	if is_on_floor() and pit_ray.is_colliding() and was_on_ledge == true:
		print("no longer on edge")
		was_on_ledge = false
	
	handleJumpAnimation()
	
	var was_on_floor = is_on_floor()
	
	move_and_slide()
	boxCollision()
	
	if !was_on_floor and is_on_floor():
		landing_player.pitch_scale = rng.randf_range(0.85, 1.15)
		landing_player.play()
		
	if was_on_floor and !is_on_floor():
		#print(is_on_floor())
		if !velocity.y < 0: 
			coyote_timer.start()
			print("coyote timer started")

	
	# pelaajan hyökätessä toistetaan hyökkäysanimaatio- ja ääniefektit
	if Input.is_action_just_pressed("attack") and can_attack:
		hitbox.look_at(get_global_mouse_position())
		if get_global_mouse_position().x < global_position.x:
			attack.flip_v = true
		else: attack.flip_v = false
		print("attack")
		attack_animation_player.play("attack")
		attack_player.pitch_scale = rng.randf_range(0.85, 1.15)
		attack_player.play()
		can_attack = false
		cooldowntimer.start()

#hyökkäyksen varsinainen logiikka
func _on_hit_box_area_entered(area: Area2D) -> void:
	if area.is_in_group("hurtbox"):
		print("enemy damaged")
		hit_player.pitch_scale = rng.randf_range(0.8, 1.2)
		hit_player.play()
		area.damage()

func _on_attack_timer_timeout() -> void:
	can_attack = true
	print("can attack")

func _on_damage_timer_timeout() -> void:
	print("damage timer reset!")
	took_damage = false
	
func boxCollision():
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision.get_collider() is RigidBody2D:
			collision.get_collider().apply_central_impulse(-collision.get_normal() * 80)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("reset"):
		playerDeath()
		

#Jos pelaajan hp on 0 kutsuu playerDeath()
func checkHP():
	if hp <= 0: 
		playerDeath()

func getDamaged():
	if !took_damage:
		flash_animation_player.play("flash")
		damage_timer.start()
		took_damage = true
		hp = hp - 1
		health_bar._set_health(hp)
		print(hp)
		checkHP()

#alustaa scenen pelaajan kuollessa
func playerDeath():
	get_tree().reload_current_scene()

func _on_trap_hitbox_body_entered(body: Node2D) -> void:
	#prev_speed = speed
	#speed = 0
	water_player.pitch_scale = rng.randf_range(0.4, 0.7)
	water_player.play()
	can_move = false
	velocity.x = 0.0
	fallen()
	fall_timer.start()

func _on_heal_box_body_entered(body: Node2D) -> void:
	water_player.pitch_scale = rng.randf_range(0.8, 1.2)
	water_player.play()
	hp = max_hp
	health_bar._set_health(hp)
	
func fallen():
	getDamaged()
	position = last_position

func _on_fall_timer_timeout() -> void:
	can_move = true
	#speed = prev_speed
	
func handle_inputs(delta) -> void:
	if Input.is_action_just_pressed("jump") and (is_on_floor() or !coyote_timer.is_stopped()):
		velocity.y = JUMP_VELOCITY
		#animState.travel("jumpLoop")
		#grapple.grappleRetract()
		#animatedSprite_2d.play("Jump")
		sfx_player.play()
		coyote_timer.stop()
	elif Input.is_action_just_pressed("jump") and !has_double_jumped:
		#animatedSprite_2d.play("Jump")
		sfx_player.play()
		velocity.y = JUMP_VELOCITY
		has_double_jumped = true
	if Input.is_action_just_pressed("jump") and grapple.launched:
		grapple.grappleRetract()
		velocity.y = JUMP_VELOCITY/2
		#animatedSprite_2d.play("Jump")
		sfx_player.play()
	# Stop jump if key is released
	if Input.is_action_just_released("jump") && velocity.y < 0:
		#animState.travel("fallLoop")
		velocity.y = 0
	
	direction = Input.get_axis("moveLeft", "moveRight")
	if direction != 0:
		last_direction = direction #väliaikainen ratkaisu dashiin
	if direction == 0 and is_on_floor():
		if animation_player.is_playing(): animation_player.stop()
		animatedSprite_2d.play("Idle")
	elif direction != 0 and is_on_floor():
		if animation_player.is_playing(): animation_player.stop()
		animatedSprite_2d.play("Run")
	
	#if Input.is_action_just_pressed("jump"):
	#	movement_player.stop()

func handleJumpAnimation() -> void:
	if velocity.y < 0 and !grapple.launched:
		animation_player.play("jumpOff")
	if velocity.y > 0 and !is_on_floor():
		print("falling!")
		animation_player.stop()
		animation_player.play("fallLoop")

func playDashEffect():
	dash_player.pitch_scale = rng.randf_range(0.85, 1.15)
	dash_player.play()
