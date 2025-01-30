extends CharacterBody2D

const ACCELERATION = 30000
const FRICTION = 30000
const SPEED = 100.0
const JUMP_VELOCITY = -300.0


func _physics_process(delta: float) -> void:
	# Apply gravity
	addGravity(delta)
	#jumping
	handleJump(delta)
	# Get the input direction/axis
	var direction := Input.get_axis("Left", "Right")
	# Accel or deccel in desired direction depending on input
	accelOrDeccel(direction, delta)
	
	move_and_slide()
	
	print(mousePosX())
	
func hammerSwing(mousePosX):
	if mousePosX >= 0:
		#if mousePosX * transform.scale.x < 1
			# transform.scale.x = 1 to flip sprite
		# play swing animation 
		# hit detection on right hitbox, maybe before swing?
		
		# 
	#if mousePosX * transform.scale.x < 1	
		# transform.scale.x = -1 to flip sprite
		# play swing animation 
		# hit detection on left hitbox, maybe before swing?
		
		pass 	
	
func mousePosX() -> float:
	var mousePos = get_global_mouse_position().x - global_position.x
	return mousePos
	
func accelOrDeccel(direction, delta):
	if direction != 0:
		velocity.x = move_toward(velocity.x,SPEED*direction, ACCELERATION*delta)	
	else:
		velocity.x = move_toward(velocity.x, 0, FRICTION*delta)
		
		
func addGravity(delta:float)-> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
		
func handleJump(delta:float)-> void:
	if Input.is_action_just_pressed("Up") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	else:
		if Input.is_action_just_released("Up") and velocity.y < JUMP_VELOCITY / 2:
			velocity.y = JUMP_VELOCITY /2
