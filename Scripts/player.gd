extends CharacterBody2D



const HAMMER_SCENE = preload("res://Scenes/hammer.tscn")
const ACCELERATION = 30000
const FRICTION = 30000
const SPEED = 100.0
const JUMP_VELOCITY = -300.0

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


var hammerLess = false
var time = 0.0

func _ready():
	Global.hammerReturned.connect(_on_hammer_returned)
	
# single input events handled here
func _input(event: InputEvent) -> void:	
	if not hammerLess:	
		if event.is_action_pressed("SwingHammer"):
			hammerSwing(mouseDirX())
		if event.is_action_pressed("Throw Hammer") and animated_sprite_2d.animation != "swing
		" and $ThrowTimer.is_stopped():
			hammerThrow(mouseDirX())
	
# physics dependent events here	(most stuff is)
func _physics_process(delta: float) -> void:
	# Get the input direction/axis
	var direction := Input.get_axis("Left", "Right")
	
	addGravity(delta)
	handleJump(delta)	
	accelOrDeccel(direction, delta)
	updateAnimations(direction,mouseDirX())	
	move_and_slide()
	
#Get mouse x direction relative to player and return as an int	
func mouseDirX() -> int:
	var mouseDir = 0
	var mousePosX = get_global_mouse_position().x - global_position.x
	if mousePosX >=0:
		mouseDir = 1
	else:
		mouseDir = -1	
	return mouseDir

#Get mousepos relative to player	
func mousePos() -> Vector2:
	var mousePos = get_global_mouse_position() - global_position
	return mousePos
	
#Acceleration depending on input or no input	
func accelOrDeccel(direction, delta):
	if direction != 0:
		velocity.x = move_toward(velocity.x,SPEED*direction, ACCELERATION*delta)	
	else:
		velocity.x = move_toward(velocity.x, 0, FRICTION*delta)
		
#Gravity
func addGravity(delta:float)-> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

#High or short jump depending on if key is held 		
func handleJump(delta:float)-> void:
	if Input.is_action_just_pressed("Up") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	else:
		if Input.is_action_just_released("Up") and velocity.y < JUMP_VELOCITY / 2:
			velocity.y = JUMP_VELOCITY /2
			
#Instantiate new hammer scene(hitbox)
func instantiateHammer(mouseDirX):
		
	var hammer = HAMMER_SCENE.instantiate()
	hammer.position = global_position
	hammer.direction = mouseDirX
	
	get_parent().add_child(hammer)	
	return hammer

#Throw hammer from the correct position	
func hammerThrow(mouseDirX) -> void:
		instantiateHammer(mouseDirX()).position += Vector2(0,-25)		
		Global.startThrow.emit()
		hammerLess = true


#Swing hammer left or right depending on mouse pos (+ or - 1)
func hammerSwing(mouseDirX):	
	if not hammerLess:
		if $SwingTimer.is_stopped():
			instantiateHammer(mouseDirX()).position +=  Vector2(mouseDirX*28,-20)
			Global.startSwing.emit()
			animated_sprite_2d.play("swing")
			$SwingTimer.start()
	
	
#Animations					
func updateAnimations(direction,mouseDirX):
	animated_sprite_2d.scale.x = mouseDirX
	if not hammerLess:
		if not (animated_sprite_2d.animation == "swing" and animated_sprite_2d.is_playing()):
			if direction == 0:
				animated_sprite_2d.play("idle")
			else: 
				animated_sprite_2d.scale.x = direction
				animated_sprite_2d.play("run")
			if not is_on_floor():
				animated_sprite_2d.play("jump")		
	else:
		if not (animated_sprite_2d.animation == "swing" and animated_sprite_2d.is_playing()):
			if direction == 0:
				animated_sprite_2d.play("idle_hammerless")
			else: 
				animated_sprite_2d.scale.x = direction
				animated_sprite_2d.play("run_hammerless")
			if not is_on_floor():
				animated_sprite_2d.play("jump_hammerless")			

# stop looping hit animation 
func _on_timer_timeout() -> void:
	time +=$SwingTimer.wait_time
	if time > 0.34:
		animated_sprite_2d.stop()
		
func _on_hammer_returned():
	$ThrowTimer.start()
	hammerLess = false


func _on_throw_timer_timeout() -> void:
	pass # Replace with function body.
