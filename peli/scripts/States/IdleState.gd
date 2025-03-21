#IdleState
extends PlayerState

func enterState(playerNode):
	super(playerNode)
	#player.velocity.x = 0
	#if player.velocity.x > 0:player.velocity.x = lerp(player.velocity.x, 0.0, 0.2)
	#player.velocity.x = lerp(player.velocity.x, 0.0, 0.1)
	

func handleInput(_delta):
	#if player.is_on_floor():player.velocity.x = lerp(player.velocity.x, 0.0, 0.2)
	if Input.is_action_just_pressed("jump") and (player.is_on_floor() or player.can_double_jump == true):
		if not player.is_on_floor(): player.can_double_jump = false
		player.changeState("JumpingState")
	
	elif Input.get_axis("moveLeft", "moveRight") != 0:
		player.changeState("MovingState")
	
func _physics_process(delta: float) -> void:
	# Hidastetaan vain, jos nopeus on yhä suurempi kuin pieni arvo
	if abs(player.velocity.x) > 1.0:
		player.velocity.x = lerp(player.velocity.x, 0.0, 0.1)
	else:
		player.velocity.x = 0  # Varmistetaan, ettei jää pieniä arvoja
func exitState():
	pass
	
