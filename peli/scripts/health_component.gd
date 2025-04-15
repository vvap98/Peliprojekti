extends Node2D

class_name hpComponent

@export var MAXHP = 3
var hp : int


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hp = MAXHP


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func checkHp():
	if hp <= 0:
		death()

func getDamaged():
	hp = hp - 1
	print(hp)
	get_parent().playDamageAnimation()
	get_parent().getKnockedBack()
	checkHp()

func death():
	print("Enemy killed")
	# self.visible = false
	# self.set_deferred("monitoring", false)
	get_parent().queue_free()
