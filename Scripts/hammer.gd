extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_entered(area: Area2D) -> void:
	print("hammer area entered")


func _on_body_entered(body: Node2D) -> void:
	print("hammer body entered")


func _on_timer_timeout() -> void:
	queue_free()
