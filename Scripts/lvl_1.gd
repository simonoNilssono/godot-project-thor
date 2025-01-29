extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	# Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN
	pass # Replace with function body.
	
# single input events handled here
func _input(event):
	if event.is_action_pressed("quit"):
		get_tree().quit()	
		
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
