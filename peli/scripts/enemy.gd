class_name GroundEnemy extends Entity
#extends CharacterBody2D
# TODO vihu kääntyy, kun on kielekkeellä
# TODO vihu tarkistaa myös pituussuunnassa kuinka lähellä pelaaja on

@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var ray_cast_edge: RayCast2D = $RayCastEdge


const SPEED = 120.0
var player

var knockback = Vector2.ZERO
var knockbackforce = 900.0
var dir = Vector2(1.0, 1.0)

func _ready():
	player = get_tree().get_first_node_in_group("player")
	hp = 3
	
func _physics_process(delta: float) -> void:
	#Get gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

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

func _process(_delta: float) -> void:
	checkHp() 

func platformEdge():
	if !ray_cast_edge.is_colliding():
		dir = -dir
		ray_cast_edge.position.x *= -1

func checkHp():
	if hp <= 0:
		enemyDeath()

func getDamaged():
	hp = hp - 1
	print(hp)
	knockback = -dir * knockbackforce
	
func enemyDeath():
	print("Enemy killed")
	# self.visible = false
	# self.set_deferred("monitoring", false)
	queue_free()
