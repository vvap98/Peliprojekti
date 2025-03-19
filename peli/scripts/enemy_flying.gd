extends CharacterBody2D

# TODO bugi: vihu jää jumiin kulmiin

const SPEED = 100
var direction = 1
var playerchase = false

var hp = 1
var ogposition

@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D

var player # = null
func _ready():
	set_physics_process(false)
	await get_tree().physics_frame
	set_physics_process(true)
	player = get_tree().get_first_node_in_group("player")
	makePath()
	ogposition = position
	
func _physics_process(delta: float) -> void:
	#Get gravity
	#if not is_on_floor():
	#	velocity += get_gravity() * delta
	#if playerchase:
	var next_path_pos = nav_agent.get_next_path_position()
	var dir = global_position.direction_to(next_path_pos)
	#print(player.global_position)
	#print(dir)
	velocity = dir * SPEED
		#position += (player.position - position).normalized() * SPEED
	#lif position != ogposition:
	#	position += (ogposition - position).normalized() * SPEED
		#position.x += direction * SPEED * delta
		
	#print(position)
	
	move_and_slide()

func _process(delta: float) -> void:
		checkHp()

func _on_detection_zone_body_entered(player) -> void:
	#player = body
	playerchase = true

func _on_detection_zone_body_exited(player) -> void:
	#player = null
	playerchase = false
	
func makePath() -> void:
	nav_agent.target_position = player.global_position 
	print(nav_agent.target_position)

func checkHp():
	if hp <= 0:
		enemyDeath()

func getDamaged():
	hp = hp - 1
	print(hp)
	
func enemyDeath():
	print("ded")
	# self.visible = false
	# self.set_deferred("monitoring", false)
	queue_free()


func _on_timer_timeout() -> void:
	makePath()
