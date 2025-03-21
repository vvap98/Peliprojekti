class_name GroundEnemy extends Entity
#extends CharacterBody2D
# TODO vihu kääntyy, kun on kielekkeellä
# TODO vihu tarkistaa myös pituussuunnassa kuinka lähellä pelaaja on

@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var ray_cast_edge: RayCast2D = $RayCastEdge


const SPEED = 120.0
var direction = 1
var player
func _ready():
	player = get_tree().get_first_node_in_group("player")
	hp = 1
	
func _physics_process(delta: float) -> void:
	#Get gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	if ray_cast_right.is_colliding(): #or player.position.x < position.x and player.position.x >= position.x - 200:
		direction = -1
		ray_cast_edge.position.x *= -1
	if ray_cast_left.is_colliding(): #or player.position.x > position.x and player.position.x <= position.x + 200:
		direction = 1
		ray_cast_edge.position.x *= -1
	
	platformEdge()
	position.x += direction * SPEED * delta
	#print(position)
	
	move_and_slide()

func _process(_delta: float) -> void:
	checkHp() 

func platformEdge():
	if !ray_cast_edge.is_colliding():
		direction = -direction
		ray_cast_edge.position.x *= -1

func checkHp():
	if hp <= 0:
		enemyDeath()

func getDamaged():
	hp = hp - 1
	print(hp)
	
func enemyDeath():
	print("Enemy killed")
	# self.visible = false
	# self.set_deferred("monitoring", false)
	queue_free()
