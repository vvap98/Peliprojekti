extends StaticBody2D

class_name unlockableGate

var was_closed : bool

@export var buttons : int
@onready var audio_player: AudioStreamPlayer2D = $AudioStreamPlayer2D

func _ready() -> void:
	print(buttons)
	was_closed = false
	
func _process(delta: float) -> void:
	if buttons == 0 and !was_closed:
		audio_player.play()
		#print("gate disabled!")
		was_closed = true
		self.visible = false
		self.set_deferred("monitoring", false)
		self.get_node("CollisionShape2D").set_deferred("disabled", true)
	if buttons != 0 and was_closed:
		was_closed = false
		self.visible = true
		self.set_deferred("monitoring", true)
		self.get_node("CollisionShape2D").set_deferred("disabled", false)
