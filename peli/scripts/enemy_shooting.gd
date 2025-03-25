extends CharacterBody2D


var hp = 3
#@onready var world = get_tree().get_root().get_node("world")
@onready var projectile = load("res://scenes/projectile.tscn")
@onready var animation_player: AnimationPlayer = $Sprite2D/AnimationPlayer

var world
var playerchase = false
var player

func _physics_process(delta: float) -> void:
	if playerchase:
		look_at(player.global_position)

func _process(_delta: float) -> void:
	checkHp()
	
func _ready() -> void:
	world = get_tree().get_root().get_node("World")
	player = get_tree().get_first_node_in_group("player")

func shoot():
	var instance = projectile.instantiate()
	instance.dir = rotation + PI/2
	instance.spawnPos = global_position
	instance.spawnRot = rotation + PI/2
	instance.zdex = z_index - 1
	world.add_child.call_deferred(instance)

func checkHp():
	if hp <= 0:
		enemyDeath()

func getDamaged():
	animation_player.play("damage")
	hp = hp - 1
	print(hp)
	
func enemyDeath():
	print("ded")
	# self.visible = false
	# self.set_deferred("monitoring", false)
	queue_free()

func _on_timer_timeout() -> void:
	if playerchase:
		shoot()


func _on_detection_zone_body_entered(body: Node2D) -> void:
	if body == player:
		playerchase = true


func _on_detection_zone_body_exited(body: Node2D) -> void:
	if body == player:
		playerchase = false
