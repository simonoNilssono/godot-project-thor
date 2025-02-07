extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Input.mouse_mode = Input.MOUSE_MODE_CONFINED
	#makes menu controllable by arrow key. mouse is usable as default.
	$VBoxContainer/PlayBtn.grab_focus()


func _on_play_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/lvl_1.tscn")


func _on_help_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/help.tscn")


func _on_quit_btn_pressed() -> void:
	get_tree().quit()
