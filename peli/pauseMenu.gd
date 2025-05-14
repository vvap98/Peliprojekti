extends Control
#Pausemenu. Lisää kenttään CanvasLayer ja tämä sen alanodeksi. Varmista että Process Mode == Always asetuksista


func _ready():
	$AnimationPlayer.play("RESET")
		
func resume():
	get_tree().paused = false
	$AnimationPlayer.play_backwards("menuBlur")
	visible = false
func pause():
	get_tree().paused = true
	visible = true
	$AnimationPlayer.play("menuBlur")
	
func escPressed():
	if Input.is_action_just_pressed("esc"):
		if get_tree().paused == false:
			pause()
		elif get_tree().paused == true:
			resume()


func _on_resume_pressed() -> void:
	resume()

func _on_restart_pressed() -> void:
	resume()
	get_tree().reload_current_scene()

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_fullscreen_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

func _process(delta):
	escPressed()
