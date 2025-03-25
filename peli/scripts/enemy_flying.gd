extends CharacterBody2D

# TODO bugi: vihu jää jumiin kulmiin

const SPEED = 100
var direction = 1
var playerchase = false

var hp = 3
var ogposition

var knockback = Vector2.ZERO
var knockbackforce = 900.0
var dir : Vector2
var new_velocity : Vector2

@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@onready var animation_player: AnimationPlayer = $Sprite2D/AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D

var player # = null
func _ready():
	#set_physics_process(false)
	#await get_tree().physics_frame
	#set_physics_process(true)
	player = get_tree().get_first_node_in_group("player")
	pathSetup()
	ogposition = position
	
func _physics_process(_delta: float) -> void:
	await get_tree().physics_frame

	if dir.x > 0:
		sprite_2d.flip_h = true
	if dir.x < 0:
		sprite_2d.flip_h = false	
	if playerchase:
		nav_agent.target_position = player.global_position 
		var next_path_pos = nav_agent.get_next_path_position()
		dir = global_position.direction_to(next_path_pos)
		new_velocity = dir * SPEED + knockback
	#print(player.global_position)
	#print(dir)
	else:
		nav_agent.target_position = ogposition
		var next_path_pos = nav_agent.get_next_path_position()
		dir = global_position.direction_to(next_path_pos)
		new_velocity = dir * SPEED + knockback
	#lif position != ogposition:
	#	position += (ogposition - position).normalized() * SPEED
		#position.x += direction * SPEED * delta
	knockback = lerp(knockback, Vector2.ZERO, 0.15)
	#print(position)
	
	if nav_agent.avoidance_enabled:
		nav_agent.set_velocity(new_velocity)
	else:
		_on_navigation_agent_2d_velocity_computed(new_velocity)
	move_and_slide()

func _process(_delta: float) -> void:
	checkHp()

func pathSetup():
	await get_tree().physics_frame
	nav_agent.target_position = player.global_position 

func _on_detection_zone_body_entered(body) -> void:
	#player = body
	if body == player:
		playerchase = true

func _on_detection_zone_body_exited(body) -> void:
	if body == player:
		playerchase = false
	
func makePath() -> void:
	nav_agent.target_position = player.global_position 
	print(nav_agent.target_position)

func checkHp():
	if hp <= 0:
		enemyDeath()

func getDamaged():
	animation_player.play("damage")
	hp = hp - 1
	print(hp)
	knockback = -dir * knockbackforce
	
func enemyDeath():
	print("ded")
	# self.visible = false
	# self.set_deferred("monitoring", false)
	queue_free()


func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	velocity = safe_velocity
