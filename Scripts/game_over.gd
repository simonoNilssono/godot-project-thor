extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED
	#makes menu controllable by arrow key. mouse is usable as default.
	$VBoxContainer/PlayAgainBtn.grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_play_again_btn_pressed() -> void:
	pass # Replace with function body.


func _on_main_menu_btn_pressed() -> void:
	pass # Replace with function body.


func _on_quit_btn_pressed() -> void:
	pass # Replace with function body.
