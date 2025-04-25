extends Area2D

@export var gate : unlockableGate

func _on_body_entered(body: Node2D) -> void:
	self.scale = Vector2(1, 0.5)
	self.get_node("CollisionShape2D").set_deferred("disabled", true)
	if gate and gate.buttons != 0:
		gate.buttons = gate.buttons - 1
		print("gate has ", gate.buttons, "buttons left!")
