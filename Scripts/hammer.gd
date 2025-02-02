extends Area2D


var speed = 300
var direction: int
var targetPos : Vector2
var startPos : Vector2
enum State {Swung, Thrown, Returning}
var current_state = State
var hitPos=  Vector2(5,5)
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

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
		
					
#Throwing hammer towards target			
func throwing(delta):
	position += (transform.x * speed * delta)	
	
	#if target reached, return	
	if abs(position.x-startPos.x) > abs(targetPos.x-startPos.x):
		current_state = State.Returning
		
#Return hammer to player
func returning(delta):
	look_at(get_parent().get_child(0).position)
	position += (transform.x * speed * delta)
	
	#delete instance if to close to body when returning, no more hammer stuck  in ground
	if abs(position.x-get_parent().get_child(0).position.x
	) < 5 and abs(position.y-get_parent().get_child(0).position.y) < 5:
		Global.hammerReturned.emit()
		queue_free() 

#detect collisions					
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemies"):
		body.deathProcess()
		body.queue_free()
	
	#return if hit wall	
	if body.is_in_group("Terrain") and current_state == State.Thrown:
		current_state = State.Returning
	#if hammered returned, delete instance	
	if body.is_in_group("Player") and current_state == State.Returning:
		Global.hammerReturned.emit()
		queue_free()	
	

#Start swing, hide hammer sprite		
func _on_swing_timer_start():
	$SwingTimer.start()
	current_state = State.Swung
	animated_sprite_2d.visible = not animated_sprite_2d.visible
	
# end swing	
func _on_swing_timer_timeout() -> void:
	queue_free()

#start throw, initialize variables used in flight
func _on_throw_timer_start(mouseDirX,mousePos):
	$ThrowTimer.start()
	animated_sprite_2d.play("throw")
	current_state = State.Thrown
	look_at(get_global_mouse_position())
	targetPos = get_global_mouse_position()
	startPos = get_parent().get_child(0).position	
	direction = mouseDirX

# delete if hammer survives too long, rarely used	
func _on_throw_timer_timeout() -> void:
	Global.hammerReturned.emit()
	queue_free()
