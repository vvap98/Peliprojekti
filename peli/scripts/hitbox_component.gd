extends Area2D

@export var health_component : hpComponent

func damage():
	if health_component:
		health_component.getDamaged()
