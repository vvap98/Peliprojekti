extends Control

@onready var health_bar: ProgressBar = $healthBar
@onready var damage_bar: ProgressBar = $healthBar/damageBar
@onready var timer: Timer = $healthBar/Timer

var health

func _set_health(new_health):
	var prev_health = health
	health = min(health_bar.max_value, new_health)
	health_bar.value = health
	
	if health <= 0:
		queue_free()
	
	if health < prev_health:
		timer.start()
	else:
		damage_bar.value = health

func init_health(_health):
	health = _health
	health_bar.max_value = health
	health_bar.value = health
	damage_bar.max_value = health
	damage_bar.value = health



func _on_timer_timeout() -> void:
	damage_bar.value = health
