#JumpingState
#Tila pelaajan hypyn käsittelemiselle
extends PlayerState


func enterState(playerNode):
	super(playerNode) #kutsuu PlayerState luokan enterState metodia
	player.velocity.y = player.JUMP_VELOCITY

func exitState():
	pass

#Pelaaja maassa --> IdleState
#Pelaaja painaa dash hypyn aikana --> DashingState
#Pelaaja liikkuu hypyn aikana --> MovingState
func handleInput(_delta):
	if player.is_on_floor():
		player.changeState("IdleState")
	
	elif Input.is_action_just_pressed("dash"):
		player.changeState("DashingState")
	elif ["moveLeft", "moveRight"].any(Input.is_action_pressed): #Jos pelaaja liikkuu hypyn aikana, siirrytään MovingState
		player.changeState("MovingState")
	elif Input.is_action_just_pressed("jump") and player.can_double_jump == true:
		player.can_double_jump = false
		player.velocity.y = player.JUMP_VELOCITY
