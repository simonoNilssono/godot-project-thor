extends Area2D

const SPEED = 300

# left or right, -1 or 1
var direction: int

var targetPos : Vector2
var startPos : Vector2
enum State {Swung, Thrown, Returning, Hover}
var current_state : State
var player : Node2D
var playerFlying = false
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_parent().get_child(0)
	Global.startSwing.connect(_on_swing_timer_start)
	Global.startThrow.connect(_on_throw_timer_start)
	Global.hover.connect(_on_hover)
	Global.flying2Hammer.connect(_on_fly2Hammer)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	match current_state:
		State.Swung:
			swinging() 
		State.Thrown:
			throwing(delta)	
		State.Returning:
			returning(delta)
		State.Hover:
			hovering()

#Start swing, hide hammer sprite
func _on_swing_timer_start() -> void:
	$SwingTimer.start()
	current_state = State.Swung
	
	#hide the spinning sprite during swing
	animated_sprite_2d.visible = not animated_sprite_2d.visible

#Make hammer swing hitbox follow player and not be stuck in one place
func swinging() -> void:
	position = player.position 
	position += Vector2(direction*28,-20)

#End swing	
func _on_swing_timer_timeout() -> void:
	queue_free()	

#Start throw, initialize variables used in flight
func _on_throw_timer_start() -> void:
	$ThrowTimer.start()
	animated_sprite_2d.play("throw")
	current_state = State.Thrown
	
	#set mouse position as target 
	targetPos = get_global_mouse_position()
	#initial rotation towards target
	look_at(targetPos)
	#assign start position
	startPos = player.position	

#Throwing hammer towards target
func throwing(delta) -> void:
	position += (transform.x * SPEED * delta)
	
	#if target reached, set state to return
	if abs(position.x-startPos.x) > abs(targetPos.x-startPos.x):
		current_state = State.Returning

#hover signal received, set state to hover
func _on_hover():
	current_state = State.Hover

# for future functionality, maybe emit some particles while hovering
func hovering():
	pass

#Return hammer to player
func returning(delta) -> void:
	look_at(player.position)
	position += (transform.x * SPEED * delta)

	#delete instance if to close to body when returning, no more hammer stuck  in ground
	if abs(position.x-player.position.x) < 5 and abs(position.y-player.position.y) < 5:
		Global.hammerReturned.emit()
		

#Return hammer if instance survives the whole timer
func _on_throw_timer_timeout() -> void:
	current_state = State.Returning

#player is flying 2 hammer
func _on_fly2Hammer() -> void:
	playerFlying = true
	

#Detect collisions
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemies"):
		body.deathProcess()
		body.queue_free()
		
	#return if hit wall
	if body.is_in_group("Terrain") and current_state == State.Thrown:
		current_state = State.Returning
		
	#if hammer returned, delete instance	
	if body.is_in_group("Player") and current_state == State.Returning:
		Global.hammerReturned.emit()
	
	#if hammer collides with flying player
	if body.is_in_group("Player") and playerFlying == true :
		Global.hammerReturned.emit()
		
		
