extends CharacterBody2D

# TODO vihu kääntyy, kun on kielekkeellä
# TODO vihu tarkistaa myös pituussuunnassa kuinka lähellä pelaaja on
# TODO vihulle alue pelaajan havaitsemiseksi
# TODO vihu jahtaa pelaajaa

const SPEED = 300.0
#var direction = 1
var playerchase = false

var hp = 1

@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var ray_cast_right: RayCast2D = $RayCastRight

var player # = null
func _ready():
	player = get_tree().get_first_node_in_group("player")
	
func _physics_process(delta: float) -> void:
	#Get gravity
	#if not is_on_floor():
	#	velocity += get_gravity() * delta
	if playerchase:
		position += (player.position - position)/SPEED
		
	#if position.x == player.position.x:
	#	velocity.x = 0
	
	#if ray_cast_right.is_colliding() or player.position.x < position.x and player.position.x >= position.x - 200:
	#	direction = -1
	#if ray_cast_left.is_colliding() or player.position.x > position.x and player.position.x <= position.x + 200:
	#	direction = 1
	
	
		
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
