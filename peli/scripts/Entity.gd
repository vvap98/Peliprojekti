class_name Entity 
extends CharacterBody2D

var hp
var knockback
var damage

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
