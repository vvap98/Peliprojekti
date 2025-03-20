extends CharacterBody2D


@export var SPEED = 300.0
const JUMP_VELOCITY = -400.0

var dir : float
var spawnPos : Vector2
var spawnRot : float

func _ready():
	global_position = spawnPos
	global_rotation = spawnRot

func _physics_process(delta: float) -> void:
	velocity = Vector2(0, -SPEED).rotated(dir)
	move_and_slide()
