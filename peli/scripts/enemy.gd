extends CharacterBody2D

# TODO vihu kääntyy, kun on kielekkeellä
# TODO vihu tarkistaa myös pituussuunnassa kuinka lähellä pelaaja on
const SPEED = 120.0
var direction = 1

var hp = 1

@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var ray_cast_right: RayCast2D = $RayCastRight

var player
func _ready():
	player = get_tree().get_first_node_in_group("player")
	
func _physics_process(delta: float) -> void:
	#Get gravity
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if position.x == player.position.x:
		velocity.x = 0
	
	if ray_cast_right.is_colliding() or player.position.x < position.x and player.position.x >= position.x - 200:
		direction = -1
	if ray_cast_left.is_colliding() or player.position.x > position.x and player.position.x <= position.x + 200:
		direction = 1
	position.x += direction * SPEED * delta
	print(position)
	
	move_and_slide()

func _process(delta: float) -> void:
		checkHp()

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
