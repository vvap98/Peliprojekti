#MovingState
extends PlayerState


#func enterState(playerNode):
#	super(playerNode)

func exitState():
	pass
	
func handleInput(_delta):
		
	var direction = Input.get_axis("moveLeft","moveRight")
	if direction > 0:
		player.velocity.x = min(player.velocity.x + player.ACCELERATION, player.SPEED)
	elif direction < 0:
		player.velocity.x = max(player.velocity.x - player.ACCELERATION, -player.SPEED)
	else:
		player.changeState("IdleState")
	
	if Input.is_action_just_pressed("jump") and (player.is_on_floor() or player.can_double_jump == true):
		if not player.is_on_floor(): player.can_double_jump = false
		player.changeState("JumpingState")
	
