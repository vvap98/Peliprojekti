#TODO Korjaa fysiikan käsittely heilumiselle. crosshair
extends Node2D

@export var rest_length = 15.0 #Tarttumisköyden pituus lepotilassa
@export var stiffness = 13.0 # Voima jolla pelaajaa vedetään tarttumispistettä kohti
@export var damping = 2.0 #liikkeen vaimennus

@onready var player := get_parent()
@onready var ray := $RayCast2D #Tarttumisköyden raycast
@onready var rope := $Line2D #Piirrettävä tarttumisköysi
@onready var shape : ShapeCast2D = $ShapeCast2D

@onready var attach_player: AudioStreamPlayer2D = $AttachPlayer
@onready var detach_player: AudioStreamPlayer2D = $DetachPlayer

@onready var timer: Timer = $Timer
var spike_ready = true
var body

var launched = false # Onko pelaaja laukaissut tarttumis "köyden"
var target: Vector2 #Tarttumisen kohteen muuttuja
var crosshair_position: Vector2 # Tähtäimen sijainti

func _process(delta: float) -> void:
	ray.look_at(get_global_mouse_position()) #tähtää muuttujan "ray" hiiren osoittamaan kohtaan
	#ray.target_position = get_global_mouse_position() - player.global_position
	shape.look_at(get_global_mouse_position())
	queue_redraw()
	#print(shape.target_position)
	
	
	
	if Input.is_action_just_pressed("grapple"):
		grappleLaunch()
	if Input.is_action_just_released("grapple"):
		grappleRetract()
	if launched:
		handleGrapple(delta)
		
		

func _draw() -> void:
	var direction = ray.target_position.rotated(ray.global_rotation).normalized()
	var offset_distance = 250.0  #Kuinka kaukana tähtäin on pelaajasta
	var start = ray.global_position + direction * offset_distance
	var end = ray.global_position + ray.target_position.rotated(ray.global_rotation)
	
	if not launched: draw_line(to_local(start), to_local(end), Color.RED, 2)
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
	#force += Vector2(0, ProjectSettings.get_setting("physics/2d/default_gravity"))

	player.velocity += force * delta
	updateRope()
#Tarttumisköyden laukaisu.	
func grappleLaunch():
	if ray.is_colliding():
		attach_player.play()
		launched = true
		target = ray.get_collision_point()
		rope.show()
	#if shape.is_colliding:
		#print(ray.get_collision_count())
		#for i in ray.get_collision_count():
		body = ray.get_collider()
		print(body)
		if body.is_in_group("spiketrap"):
			detach_player.play()
			grappleRetract()
			if spike_ready:
				body.spawn_spike()
				spike_ready = false
				timer.start()
			print("spiketrap found")
				
#Tarttumisköyden irroitus.
func grappleRetract():
	#detach_player.play()
	launched = false
	rope.hide()
	
#piirtää köyden
func updateRope():
	rope.set_point_position(1, to_local(target))


func _on_timer_timeout() -> void:
	spike_ready = true
