#TODO Korjaa fysiikan käsittely heilumiselle. crosshair
extends Node2D

@export var rest_length = 30.0 #Tarttumisköyden pituus lepotilassa
@export var stiffness = 13.0 # Voima jolla pelaajaa vedetään tarttumispistettä kohti
@export var damping = 2.0 #liikkeen vaimennus

@onready var player := get_parent()
@onready var ray := $RayCast2D #Tarttumisköyden raycast
@onready var rope := $Line2D #Piirrettävä tarttumisköysi

var launched = false # Onko pelaaja laukaissut tarttumis "köyden"
var target: Vector2 #Tarttumisen kohteen muuttuja
var crosshair_position: Vector2 # Tähtäimen sijainti

func _process(delta: float) -> void:
	ray.look_at(get_global_mouse_position()) #tähtää muuttujan "ray" hiiren osoittamaan kohtaan
	
	if Input.is_action_just_pressed("grapple"):
		grappleLaunch()
	if Input.is_action_just_released("grapple"):
		grappleRetract()
	if launched:
		handleGrapple(delta)
		
		
#fysiikan käsittely tarttumisen aikana
func handleGrapple(delta):
	var targetDir = player.global_position.direction_to(target)
	var targetDist = player.global_position.distance_to(target)
	
	var displacement = targetDist - rest_length  #kuinka pitkälle köysi on vedetty yli rest_length
	var force = Vector2.ZERO
	
	if displacement > 0: #Jos köyttä on venytetty niin vedetään pelaajaa takaisin
		var springForceMagnitude = stiffness * displacement
		var springForce = targetDir * springForceMagnitude
		
		var velocityDot = player.velocity.dot(targetDir)
		var dampingForce = -damping * velocityDot * targetDir
		
		force = springForce + dampingForce
	force += Vector2(0, ProjectSettings.get_setting("physics/2d/default_gravity"))

	player.velocity += force * delta
	updateRope()
#Tarttumisköyden laukaisu.	
func grappleLaunch():
	if ray.is_colliding():
		launched = true
		target = ray.get_collision_point()
		rope.show()
		
#Tarttumisköyden irroitus.
func grappleRetract():
	launched = false
	rope.hide()
	
#piirtää köyden
func updateRope():
	rope.set_point_position(1, to_local(target))
