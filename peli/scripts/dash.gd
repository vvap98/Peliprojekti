extends Node2D

@onready var player: CharacterBody2D = get_parent()
@onready var playerSprite: Sprite2D =  player.get_child(0) #Viite pelaajan spriteen TODO korjaa paremmaksi
@onready var dashTimer: Timer = $dashTimer #timer dashille
@onready var dashAnimationTimer: Timer = $dashAnimationTimer #timer dashin animaatiolle
var dashing = false #onko dash käynnissä
var dashDirection : int
var dashMultiplier = 3 #arvo millä pelaajan liike kerrotaan dashin aikana. 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_parent().ready


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if dashing: dash()
	if Input.is_action_just_pressed("dash") and not dashing:
		handleDash()

#Aloittaa dashin ja käynnistää timerit
func handleDash():
	dashing = true
	dashDirection = -1 if playerSprite.flip_h else 1
	dashTimer.start()
	dashAnimationTimer.start()
	
	

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

func dash():
	player.velocity.x = dashDirection * player.SPEED * dashMultiplier
	player.velocity.y = 0

func _on_dash_timer_timeout() -> void:
	dashing = false
	dashAnimationTimer.stop()


func _on_dash_animation_timer_timeout() -> void:
	playDashAnimation()
