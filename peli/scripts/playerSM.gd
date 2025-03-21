extends CharacterBody2D

# TODO hahmolle hetkellinen kuolemattomuus sen jälkeen kun on ottanut damagea

const SPEED = 300.0
const JUMP_VELOCITY = -700.0
const ACCELERATION = 40
var currentState
var lastDirection = 1 #1 oikea ,-1 vasen

var hp =5
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
@onready var ray := $RayCast2D  # Tarttumisköyden raycast
@onready var rope := $Line2D    # Piirrettävä tarttumisköysi


func _ready() -> void:
	#health_bar.init_health(hp)
	changeState("IdleState")
	
func changeState(new_state_name: String):
	if currentState:
		currentState.exitState()
	currentState = get_node(new_state_name)
	if currentState:
		currentState.enterState(self)
	print(currentState)
	print(can_double_jump)
	

func _physics_process(delta: float) -> void:
	
	var direction := Input.get_axis("moveLeft", "moveRight")
	#päivitetään suunta
	if direction != 0:
		lastDirection = sign(direction)
		
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if currentState:
		currentState.handleInput(delta)
	move_and_slide()
	if direction >= 1:
		sprite_2d.flip_h = false
	elif direction <= -1:
		sprite_2d.flip_h = true
	

func _on_attack_timer_timeout() -> void:
	can_attack = true

func _on_damage_timer_timeout() -> void:
	print("damage timer reset!")
	took_damage = false

func _process(_delta: float) -> void:
	print(velocity.x)
	if is_on_floor(): 
		can_double_jump = true
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
