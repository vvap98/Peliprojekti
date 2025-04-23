extends Area2D

@export var gate : unlockableGate

func _on_body_entered(body: Node2D) -> void:
	if gate:
		print("gate disabled!")
		gate.visible = false
		gate.set_deferred("monitoring", false)
		gate.get_node("CollisionShape2D").set_deferred("disabled", true)
		print(gate.get_node("CollisionShape2D"))
