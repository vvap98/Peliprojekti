extends Node2D
#TODO lisää cooldown
@onready var player: CharacterBody2D = get_parent()
@onready var playerSprite: AnimatedSprite2D = player.get_child(0)
@onready var dashTimer: Timer = $dashTimer #timer dashille
@onready var dashAnimationTimer: Timer = $dashAnimationTimer #timer dashin animaatiolle
var dashing = false #onko dash käynnissä
var dashSpeed = 900.0
var dashCount = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_parent().ready


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if dashing and player.can_move: 
		dash()
	if (Input.is_action_just_pressed("dashLeft") or Input.is_action_just_pressed("dashRight")) and not dashing and player.can_dash == true:
		if Input.is_action_just_pressed("dashLeft"): dashSpeed = -abs(dashSpeed)
		if Input.is_action_just_pressed("dashRight"): dashSpeed = abs(dashSpeed)
		player.playDashEffect()
		if dashCount > 0:
			handleDash()
			dashCount = dashCount - 1
	if player.is_on_floor(): dashCount = 1

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
	player.velocity.x = dashSpeed
	player.velocity.y = 0


func _on_dash_timer_timeout() -> void:
	dashing = false
	dashAnimationTimer.stop()


func _on_dash_animation_timer_timeout() -> void:
	playDashAnimation()
