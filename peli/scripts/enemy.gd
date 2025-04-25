extends CharacterBody2D

@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var ray_cast_edge: RayCast2D = $RayCastEdge
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $Sprite2D/AnimationPlayer


const SPEED = 120.0
var player

var knockback = Vector2.ZERO
var knockbackforce = 900.0
var dir = Vector2(1.0, 1.0)

func _ready():
	player = get_tree().get_first_node_in_group("player")
	
func _physics_process(delta: float) -> void:
	#Get gravity
	if not is_on_floor():
		velocity += get_gravity() * delta
	if dir.x > 0:
		sprite_2d.flip_h = true
	if dir.x < 0:
		sprite_2d.flip_h = false	
	if ray_cast_right.is_colliding(): #or player.position.x < position.x and player.position.x >= position.x - 200:
		dir = -dir
		ray_cast_edge.position.x *= -1
	if ray_cast_left.is_colliding(): #or player.position.x > position.x and player.position.x <= position.x + 200:
		dir = -dir
		ray_cast_edge.position.x *= -1
	
	platformEdge()
	velocity.x = dir.x * SPEED + knockback.x

	knockback = lerp(knockback, Vector2.ZERO, 0.15)
	
	move_and_slide()

func platformEdge():
	if !ray_cast_edge.is_colliding():
		dir = -dir
		ray_cast_edge.position.x *= -1

func playDamageAnimation():
	animation_player.play("damage")

func death():
	print("Enemy killed")
	# self.visible = false
	# self.set_deferred("monitoring", false)

	queue_free()


func getKnockedBack():
	if (player.global_position.x < global_position.x and dir.x > 0) or (player.global_position.x > global_position.x and dir.x < 0):
		knockback = dir * knockbackforce
	else: knockback = -dir * knockbackforce
	
func enemyDeath():
	print("Enemy killed")
	# self.visible = false
	# self.set_deferred("monitoring", false)
	queue_free()
