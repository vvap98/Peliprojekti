extends CharacterBody2D


var hp = 4
#@onready var world = get_tree().get_root().get_node("world")
@onready var projectile = load("res://scenes/projectile.tscn")
@onready var animation_player: AnimationPlayer = $Sprite2D/AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D

var world
var playerchase = false
var player

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	if playerchase:
		sprite_2d.look_at(player.global_position)
	
	move_and_slide()

	
func _ready() -> void:
	world = get_tree().get_root().get_node("World")
	player = get_tree().get_first_node_in_group("player")

func shoot():
	var instance = projectile.instantiate()
	instance.dir = sprite_2d.rotation + PI/2
	instance.spawnPos = sprite_2d.global_position
	instance.spawnRot = sprite_2d.rotation + PI/2
	instance.zdex = z_index - 1
	world.add_child.call_deferred(instance)

func getKnockedBack():
	pass

func playDamageAnimation():
	animation_player.play("damage")

func _on_timer_timeout() -> void:
	if playerchase:
		shoot()


func _on_detection_zone_body_entered(body: Node2D) -> void:
	if body == player:
		playerchase = true


func _on_detection_zone_body_exited(body: Node2D) -> void:
	if body == player:
		playerchase = false
