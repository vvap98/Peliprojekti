extends StaticBody2D

class_name unlockableGate

@export var buttons : int

func _ready() -> void:
	print(buttons)
	
func _process(delta: float) -> void:
	if buttons == 0:
		#print("gate disabled!")
		self.visible = false
		self.set_deferred("monitoring", false)
		self.get_node("CollisionShape2D").set_deferred("disabled", true)
