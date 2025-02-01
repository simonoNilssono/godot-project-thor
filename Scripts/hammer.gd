extends Area2D

var thrown = false
var speed = 300
var direction: int
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.startSwing.connect(_on_swing_timer_start)
	Global.startThrow.connect(_on_throw_timer_start)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if thrown:
		move_local_x(direction *  speed * delta)
	

func hammerThrow():
	pass	

# placeholder
func _on_area_entered(area: Area2D) -> void:
	print("area entered hammer")


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemies"):
		body.queue_free()
	
func _on_swing_timer_start():
	$SwingTimer.start()
	
func _on_swing_timer_timeout() -> void:
	queue_free()

func _on_throw_timer_start():
	$ThrowTimer.start()
	thrown = true

func _on_throw_timer_timeout() -> void:
	queue_free()
