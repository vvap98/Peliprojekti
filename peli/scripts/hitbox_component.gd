extends Area2D

@export var health_component : hpComponent

func damage():
	print("health component?")
	if health_component:
		print("yes health component :)")
		health_component.getDamaged()
