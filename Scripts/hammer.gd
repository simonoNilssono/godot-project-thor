extends Area2D


var speed = 300
var direction: int
var targetPos : Vector2
var startPos : Vector2
enum State {Swung, Thrown, Returning}
var current_state = State
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.startSwing.connect(_on_swing_timer_start)
	Global.startThrow.connect(_on_throw_timer_start)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if current_state == State.Thrown:
		throwing(delta)
	if current_state == State.Returning:
		returning(delta)
		if abs(position.x-get_parent().get_child(0).position.x) < abs(2):
			print(position)
			queue_free()
	
			
#Throwing hammer towards target			
func throwing(delta):
	position += (transform.x * speed * delta)		
	if abs(position.x-get_parent().get_child(0).position.x
	) > abs(targetPos.x-get_parent().get_child(0).position.x):
		
		current_state = State.Returning
		
#Return hammer to player
func returning(delta):
	look_at(get_parent().get_child(0).position)
	position += (transform.x * speed * delta)
	#if position.x < get_parent().get_child(0).position.x:
		#queue_free()	
					



func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemies"):
		body.deathProcess()
		body.queue_free()
	if body.is_in_group("Terrain") and current_state == State.Thrown:
		current_state = State.Returning
	if body.is_in_group("Player") and current_state == State.Returning:
		queue_free()	
	
		
func _on_swing_timer_start():
	$SwingTimer.start()
	current_state = State.Swung
	
	
func _on_swing_timer_timeout() -> void:
	queue_free()

func _on_throw_timer_start(mouseDirX,mousePos):
	$ThrowTimer.start()
	current_state = State.Thrown
	look_at(get_global_mouse_position())
	targetPos = get_global_mouse_position()
	
	startPos = get_parent().get_child(0).position	
	direction = mouseDirX
func _on_throw_timer_timeout() -> void:
	queue_free()
