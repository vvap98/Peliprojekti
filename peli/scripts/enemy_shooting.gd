extends CharacterBody2D

@export var ground = true

var hp = 4
#@onready var world = get_tree().get_root().get_node("world")
var projectile = preload("res://scenes/projectile.tscn")
@onready var animation_player: AnimationPlayer = $Sprite2D/AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var death_player: AudioStreamPlayer2D = $DeathPlayer
@onready var death_timer: Timer = $DeathTimer
@onready var detect_shape: CollisionShape2D = $DetectionZone/CollisionShape2D
@onready var shoot_player: AudioStreamPlayer2D = $ShootPlayer
@onready var hit_box: CollisionShape2D = $HitboxComponent/HitBox
@onready var kill_box: CollisionShape2D = $Killzone/CollisionShape2D

const NODE_2D = preload("res://scenes/node_2d.tscn")

var world
var playerchase = false
var player

func _physics_process(delta: float) -> void:
	if ground and not is_on_floor():
		velocity += get_gravity() * delta
	if not ground and not is_on_ceiling():
		velocity -= get_gravity() * delta 
	if playerchase:
		sprite_2d.look_at(player.global_position)
	
	move_and_slide()

	
func _ready() -> void:
	world = get_tree().get_root().get_node("World")
	player = get_tree().get_first_node_in_group("player")
	if !ground:
		self.rotation_degrees = 180

func shoot():
	var instance = projectile.instantiate()
	if ground: 
		instance.dir = sprite_2d.rotation + PI/2
		instance.spawnRot = sprite_2d.rotation + PI/2
	else:
		instance.dir = sprite_2d.rotation - PI/2
		instance.spawnRot = sprite_2d.rotation - PI/2
	instance.spawnPos = sprite_2d.global_position
	#instance.zdex = z_index - 1
	world.add_child.call_deferred(instance)
	shoot_player.play()

func getKnockedBack():
	pass
	
func death():
	print("Enemy killed")
	# self.visible = false
	# self.set_deferred("monitoring", false)
	kill_box.set_deferred("disabled", true)
	hit_box.set_deferred("disabled", true)
	detect_shape.set_deferred("disabled", true)
	death_timer.start()
	death_player.play()
	animation_player.play("death")


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


func _on_death_timer_timeout() -> void:
	queue_free()
