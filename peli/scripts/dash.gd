extends Node2D
#TODO korjaa miten dash käyttäytyy jos liikkuu samalla
@onready var player: CharacterBody2D = get_parent()
#@onready var playerSprite: Sprite2D =  player.get_child(0) #Viite pelaajan spriteen TODO korjaa paremmaksi
@onready var playerSprite: AnimatedSprite2D = player.get_child(0)
@onready var dashTimer: Timer = $dashTimer #timer dashille
@onready var dashAnimationTimer: Timer = $dashAnimationTimer #timer dashin animaatiolle
var dashing = false #onko dash käynnissä
var dashMultiplier = 3 #arvo millä pelaajan liike kerrotaan dashin aikana. 
var dashSpeed = 300.0
var dashCount = 2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_parent().ready


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	#print(player.direction)
	if dashing: dash()
	if Input.is_action_just_pressed("dash") and not dashing:
		if dashCount > 0:
			handleDash()
			dashCount = dashCount - 1
	if player.is_on_floor(): dashCount = 2

#Aloittaa dashin ja käynnistää timerit
func handleDash():
	dashing = true
	dashTimer.start()
	dashAnimationTimer.start()
	
	
#Kopioi player spriten ja laittaa sen "haamuna" seuraamaan pelaajaa dashin aikana.
func playDashAnimation():
	var copiedSprite = playerSprite.duplicate()
	get_tree().current_scene.add_child(copiedSprite) 
	copiedSprite.global_position = global_position 
	
	var animationDuration = dashTimer.wait_time / 3
	await get_tree().create_timer(animationDuration).timeout
	copiedSprite.modulate.a = 0.4
	await get_tree().create_timer(animationDuration).timeout
	copiedSprite.modulate.a = 0.2
	await get_tree().create_timer(animationDuration).timeout
	copiedSprite.queue_free()

#Varsinainen dashin liike tapahtuu tässä
func dash():
	var input_dir = Vector2.ZERO
	
	# Tarkistetaan pelaajan syötteet ja asetetaan suunta
	if Input.is_action_pressed("moveRight"):
		input_dir.x += 1
	if Input.is_action_pressed("moveLeft"):
		input_dir.x -= 1
	if Input.is_action_pressed("jump"):
		input_dir.y -= 1
	else: input_dir.x = player.last_direction #jos ei paineta mitään suuntaa niin dashataan eteenpäin

	if input_dir != Vector2.ZERO:
		input_dir = input_dir.normalized()
		input_dir.y *= 0.5 #rajoitetaan liiketta y-akselilla
	
	# Pelaajan nopeus dashin aikana
	player.velocity = input_dir * dashSpeed * dashMultiplier


func _on_dash_timer_timeout() -> void:
	dashing = false
	player.velocity.x = lerp(player.velocity.x, 0.0, 0.5)
	dashAnimationTimer.stop()


func _on_dash_animation_timer_timeout() -> void:
	playDashAnimation()
