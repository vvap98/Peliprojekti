extends CharacterBody2D

var hp = 3
#@onready var world = get_tree().get_root().get_node("world")
@onready var projectile = load("res://scenes/projectile.tscn")
var world

func _process(_delta: float) -> void:
	checkHp()
	
func _ready() -> void:
	world = get_tree().get_root().get_node("World")

func shoot():
	var instance = projectile.instantiate()
	instance.dir = rotation
	instance.spawnPos = global_position
	instance.spawnRot = rotation
	instance.zdex = z_index - 1
	world.add_child.call_deferred(instance)

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
	shoot()
