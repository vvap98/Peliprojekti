extends Area2D

@export var gate : unlockableGate
@onready var sprite_2d: Sprite2D = $Sprite2D

func _on_body_entered(body: Node2D) -> void:
	#self.scale = Vector2(1, 0.5)
	sprite_2d.frame = 3
	if gate and gate.buttons != 0:
		gate.buttons = gate.buttons - 1
		print("gate has ", gate.buttons, "buttons left!")




func _on_body_exited(body: Node2D) -> void:
	if gate and gate.buttons == 0:
		gate.buttons = gate.buttons + 1
		if gate.buttons != 0:
			#self.scale = Vector2(1, 1)
			sprite_2d.frame = 1
			#self 
